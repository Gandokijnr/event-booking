<template>
  <div class="min-h-screen py-20 px-4 sm:px-6 lg:px-8">
    <div class="max-w-7xl mx-auto">
      <div class="mb-12">
        <div class="flex items-center justify-between mb-6">
          <div>
            <h1 class="text-5xl font-display font-bold mb-2">
              <span class="text-gradient">Admin Dashboard</span>
            </h1>
            <p class="text-gray-400 text-lg">Manage tickets and bookings</p>
          </div>
          <NuxtLink to="/" class="btn-secondary flex items-center gap-2">
            <Icon name="mdi:home" />
            Home
          </NuxtLink>
        </div>

        <div class="grid md:grid-cols-4 gap-6 mb-8">
          <div class="card">
            <div class="flex items-center gap-4">
              <div class="p-3 bg-amber-500/20 rounded-lg">
                <Icon name="mdi:ticket" class="text-3xl text-amber-400" />
              </div>
              <div>
                <p class="text-gray-400 text-sm">Total Tickets</p>
                <p class="text-3xl font-bold text-white">{{ stats.totalTickets }}</p>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="flex items-center gap-4">
              <div class="p-3 bg-green-500/20 rounded-lg">
                <Icon name="mdi:ticket-confirmation" class="text-3xl text-green-400" />
              </div>
              <div>
                <p class="text-gray-400 text-sm">Tickets Sold</p>
                <p class="text-3xl font-bold text-white">{{ stats.ticketsSold }}</p>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="flex items-center gap-4">
              <div class="p-3 bg-blue-500/20 rounded-lg">
                <Icon name="mdi:receipt" class="text-3xl text-blue-400" />
              </div>
              <div>
                <p class="text-gray-400 text-sm">Total Bookings</p>
                <p class="text-3xl font-bold text-white">{{ bookings.length }}</p>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="flex items-center gap-4">
              <div class="p-3 bg-purple-500/20 rounded-lg">
                <Icon name="mdi:cash" class="text-3xl text-purple-400" />
              </div>
              <div>
                <p class="text-gray-400 text-sm">Revenue</p>
                <p class="text-3xl font-bold text-white">${{ stats.totalRevenue.toFixed(0) }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="grid lg:grid-cols-2 gap-8 mb-8">
        <div class="card">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-white flex items-center gap-2">
              <Icon name="mdi:ticket-percent" class="text-amber-400" />
              Ticket Inventory
            </h2>
            <button @click="refreshData" class="btn-secondary text-sm flex items-center gap-2">
              <Icon name="mdi:refresh" :class="{ 'animate-spin': loading }" />
              Refresh
            </button>
          </div>

          <div class="space-y-4">
            <div
              v-for="ticket in ticketTypes"
              :key="ticket.id"
              class="bg-gray-800/50 rounded-lg p-4"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="text-lg font-semibold text-white">{{ ticket.name }}</h3>
                  <p class="text-amber-400 font-semibold">${{ ticket.price }}</p>
                </div>
                <span
                  class="px-3 py-1 rounded-full text-xs font-semibold"
                  :class="
                    ticket.quantity_available - ticket.quantity_sold > 20
                      ? 'bg-green-500/20 text-green-400'
                      : ticket.quantity_available - ticket.quantity_sold > 0
                      ? 'bg-orange-500/20 text-orange-400'
                      : 'bg-red-500/20 text-red-400'
                  "
                >
                  {{ ticket.quantity_available - ticket.quantity_sold }} remaining
                </span>
              </div>

              <div class="space-y-2">
                <div class="flex justify-between text-sm">
                  <span class="text-gray-400">Available</span>
                  <span class="text-white font-semibold">{{ ticket.quantity_available }}</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-gray-400">Sold</span>
                  <span class="text-white font-semibold">{{ ticket.quantity_sold }}</span>
                </div>

                <div class="relative pt-2">
                  <div class="h-2 bg-gray-700 rounded-full overflow-hidden">
                    <div
                      class="h-full bg-gradient-to-r from-amber-500 to-orange-600 transition-all duration-500"
                      :style="{ width: `${(ticket.quantity_sold / ticket.quantity_available) * 100}%` }"
                    ></div>
                  </div>
                  <p class="text-xs text-gray-400 mt-1 text-center">
                    {{ ((ticket.quantity_sold / ticket.quantity_available) * 100).toFixed(1) }}% sold
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="card">
          <h2 class="text-2xl font-bold text-white mb-6 flex items-center gap-2">
            <Icon name="mdi:chart-bar" class="text-amber-400" />
            Sales by Ticket Type
          </h2>

          <div class="space-y-4">
            <div
              v-for="ticket in ticketTypes"
              :key="ticket.id"
              class="bg-gray-800/50 rounded-lg p-4"
            >
              <div class="flex justify-between items-center mb-2">
                <span class="text-white font-semibold">{{ ticket.name }}</span>
                <span class="text-amber-400 font-bold">${{ (ticket.price * ticket.quantity_sold).toFixed(2) }}</span>
              </div>
              <div class="flex justify-between text-sm text-gray-400">
                <span>{{ ticket.quantity_sold }} tickets</span>
                <span v-if="stats.ticketsSold > 0">{{ ((ticket.quantity_sold / stats.ticketsSold) * 100).toFixed(1) }}% of sales</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-2xl font-bold text-white flex items-center gap-2">
            <Icon name="mdi:format-list-bulleted" class="text-amber-400" />
            Recent Bookings
          </h2>
          <button @click="exportBookings" class="btn-secondary text-sm flex items-center gap-2">
            <Icon name="mdi:download" />
            Export CSV
          </button>
        </div>

        <div v-if="loading" class="text-center py-12">
          <Icon name="mdi:loading" class="text-6xl text-amber-400 animate-spin" />
        </div>

        <div v-else-if="bookings.length === 0" class="text-center py-12">
          <Icon name="mdi:inbox" class="text-6xl text-gray-600 mb-4 mx-auto" />
          <p class="text-gray-400">No bookings yet</p>
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-gray-800">
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Reference</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Customer</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Ticket Type</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Quantity</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Amount</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Payment</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Status</th>
                <th class="text-left py-3 px-4 text-gray-400 font-semibold text-sm">Date</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="booking in bookings"
                :key="booking.id"
                class="border-b border-gray-800 hover:bg-gray-800/30 transition-colors"
              >
                <td class="py-4 px-4">
                  <span class="font-mono text-amber-400 font-semibold">{{ booking.booking_reference }}</span>
                </td>
                <td class="py-4 px-4">
                  <div>
                    <p class="text-white font-semibold">{{ booking.customer_name }}</p>
                    <p class="text-gray-400 text-sm">{{ booking.customer_email }}</p>
                  </div>
                </td>
                <td class="py-4 px-4 text-white">{{ getTicketName(booking.ticket_type_id) }}</td>
                <td class="py-4 px-4 text-white font-semibold">{{ booking.quantity }}</td>
                <td class="py-4 px-4 text-amber-400 font-semibold">${{ booking.total_amount.toFixed(2) }}</td>
                <td class="py-4 px-4">
                  <span class="text-gray-300 capitalize">{{ booking.payment_method }}</span>
                </td>
                <td class="py-4 px-4">
                  <span
                    class="px-3 py-1 rounded-full text-xs font-semibold capitalize"
                    :class="
                      booking.payment_status === 'confirmed'
                        ? 'bg-green-500/20 text-green-400'
                        : booking.payment_status === 'pending'
                        ? 'bg-orange-500/20 text-orange-400'
                        : 'bg-red-500/20 text-red-400'
                    "
                  >
                    {{ booking.payment_status }}
                  </span>
                </td>
                <td class="py-4 px-4 text-gray-400 text-sm">
                  {{ formatDate(booking.created_at) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabase()

interface TicketType {
  id: string
  name: string
  price: number
  quantity_available: number
  quantity_sold: number
}

interface Booking {
  id: string
  customer_name: string
  customer_email: string
  customer_phone: string
  ticket_type_id: string
  quantity: number
  total_amount: number
  payment_method: string
  payment_status: string
  booking_reference: string
  created_at: string
}

const ticketTypes = ref<TicketType[]>([])
const bookings = ref<Booking[]>([])
const loading = ref(true)

const stats = computed(() => {
  const totalTickets = ticketTypes.value.reduce((sum, t) => sum + t.quantity_available, 0)
  const ticketsSold = ticketTypes.value.reduce((sum, t) => sum + t.quantity_sold, 0)
  const totalRevenue = bookings.value.reduce((sum, b) => sum + Number(b.total_amount), 0)

  return {
    totalTickets,
    ticketsSold,
    totalRevenue
  }
})

const fetchData = async () => {
  loading.value = true

  const [ticketsResult, bookingsResult] = await Promise.all([
    supabase.from('ticket_types').select('*').order('price', { ascending: true }),
    supabase.from('bookings').select('*').order('created_at', { ascending: false }).limit(50)
  ])

  if (ticketsResult.data) {
    ticketTypes.value = ticketsResult.data
  }

  if (bookingsResult.data) {
    bookings.value = bookingsResult.data
  }

  loading.value = false
}

const refreshData = () => {
  fetchData()
}

const getTicketName = (ticketTypeId: string) => {
  const ticket = ticketTypes.value.find(t => t.id === ticketTypeId)
  return ticket ? ticket.name : 'Unknown'
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const exportBookings = () => {
  const csv = [
    ['Reference', 'Customer Name', 'Email', 'Phone', 'Ticket Type', 'Quantity', 'Amount', 'Payment Method', 'Status', 'Date'].join(','),
    ...bookings.value.map(b => [
      b.booking_reference,
      b.customer_name,
      b.customer_email,
      b.customer_phone,
      getTicketName(b.ticket_type_id),
      b.quantity,
      b.total_amount,
      b.payment_method,
      b.payment_status,
      formatDate(b.created_at)
    ].join(','))
  ].join('\n')

  const blob = new Blob([csv], { type: 'text/csv' })
  const url = window.URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `bookings-${new Date().toISOString().split('T')[0]}.csv`
  a.click()
  window.URL.revokeObjectURL(url)
}

onMounted(() => {
  fetchData()
})

useHead({
  title: 'Admin Dashboard - Russell Crowe Indoor Garden Party',
  meta: [
    { name: 'description', content: 'Manage tickets and bookings for Russell Crowe Indoor Garden Party' }
  ]
})
</script>
