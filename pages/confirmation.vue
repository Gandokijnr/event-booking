<template>
  <div class="min-h-screen py-20 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl mx-auto">
      <div v-if="!confirmedBooking" class="card text-center py-12">
        <Icon name="mdi:alert-circle" class="text-6xl text-amber-400 mb-4 mx-auto" />
        <p class="text-xl text-gray-400 mb-6">No booking confirmation found</p>
        <NuxtLink to="/tickets" class="btn-primary">
          Book Tickets
        </NuxtLink>
      </div>

      <div v-else>
        <div class="text-center mb-12">
          <div class="inline-flex items-center justify-center w-24 h-24 bg-green-500/20 rounded-full mb-6">
            <Icon name="mdi:check-circle" class="text-6xl text-green-400" />
          </div>
          <h1 class="text-5xl font-display font-bold mb-4">
            <span class="text-gradient">Booking Confirmed!</span>
          </h1>
          <p class="text-gray-400 text-lg">Thank you for your purchase</p>
        </div>

        <div class="card mb-6">
          <div class="flex items-center justify-between mb-6 pb-6 border-b border-gray-800">
            <div>
              <p class="text-gray-400 text-sm mb-1">Booking Reference</p>
              <p class="text-3xl font-bold text-gradient">{{ confirmedBooking.reference }}</p>
            </div>
            <button @click="downloadTicket" class="btn-secondary flex items-center gap-2">
              <Icon name="mdi:download" class="text-xl" />
              Download
            </button>
          </div>

          <div class="space-y-4 mb-6">
            <div>
              <p class="text-gray-400 text-sm mb-1">Event</p>
              <p class="text-white font-semibold text-lg">Russell Crowe's Indoor Garden Party</p>
            </div>

            <div class="grid sm:grid-cols-2 gap-4">
              <div>
                <p class="text-gray-400 text-sm mb-1">Date & Time</p>
                <p class="text-white font-semibold">Saturday, December 20th, 7:00 PM</p>
              </div>
              <div>
                <p class="text-gray-400 text-sm mb-1">Venue</p>
                <p class="text-white font-semibold">Enmore Theatre, Sydney</p>
              </div>
            </div>

            <div>
              <p class="text-gray-400 text-sm mb-1">Customer Name</p>
              <p class="text-white font-semibold">{{ confirmedBooking.customerInfo.name }}</p>
            </div>

            <div>
              <p class="text-gray-400 text-sm mb-1">Email</p>
              <p class="text-white font-semibold">{{ confirmedBooking.customerInfo.email }}</p>
            </div>
          </div>

          <div class="bg-gray-800/50 rounded-lg p-4 mb-6">
            <h3 class="text-white font-semibold mb-3">Tickets</h3>
            <div class="space-y-2">
              <div
                v-for="ticket in confirmedBooking.tickets"
                :key="ticket.id"
                class="flex justify-between items-center"
              >
                <span class="text-gray-300">{{ ticket.name }} x{{ ticket.quantity }}</span>
                <span class="text-amber-400 font-semibold">${{ (ticket.price * ticket.quantity).toFixed(2) }}</span>
              </div>
            </div>
            <div class="flex justify-between items-center pt-3 mt-3 border-t border-gray-700">
              <span class="text-white font-bold">Total Paid</span>
              <span class="text-gradient text-xl font-bold">${{ confirmedBooking.total.toFixed(2) }}</span>
            </div>
          </div>

          <div class="bg-amber-500/10 border border-amber-500/30 rounded-lg p-4">
            <div class="flex items-start gap-3">
              <Icon name="mdi:information" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <div>
                <p class="text-amber-400 font-semibold mb-2">Payment Method: {{ getPaymentMethodName(confirmedBooking.paymentMethod) }}</p>
                <p class="text-gray-300 text-sm">
                  Your booking is confirmed! A confirmation email has been sent to {{ confirmedBooking.customerInfo.email }}.
                  Please complete your payment using the {{ getPaymentMethodName(confirmedBooking.paymentMethod) }} details provided.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div class="card">
          <h3 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
            <Icon name="mdi:calendar-check" class="text-amber-400" />
            What's Next?
          </h3>
          <ul class="space-y-3 text-gray-300">
            <li class="flex items-start gap-3">
              <Icon name="mdi:check" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <span>Check your email for booking confirmation and ticket details</span>
            </li>
            <li class="flex items-start gap-3">
              <Icon name="mdi:check" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <span>Complete payment using your selected payment method</span>
            </li>
            <li class="flex items-start gap-3">
              <Icon name="mdi:check" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <span>Save your booking reference: <strong class="text-amber-400">{{ confirmedBooking.reference }}</strong></span>
            </li>
            <li class="flex items-start gap-3">
              <Icon name="mdi:check" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <span>Arrive at the venue 30 minutes before the event starts</span>
            </li>
            <li class="flex items-start gap-3">
              <Icon name="mdi:check" class="text-amber-400 text-xl flex-shrink-0 mt-0.5" />
              <span>Bring a valid ID and your booking reference</span>
            </li>
          </ul>
        </div>

        <div class="text-center mt-8">
          <NuxtLink to="/" class="btn-secondary inline-flex items-center gap-2">
            <Icon name="mdi:home" class="text-xl" />
            Back to Home
          </NuxtLink>
        </div>

        <div class="text-center mt-8 text-gray-500 text-sm">
          <p>Questions? Contact us at support@russellcroweevents.com</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface ConfirmedBooking {
  tickets: Array<{
    id: string
    name: string
    price: number
    quantity: number
  }>
  total: number
  customerInfo: {
    name: string
    email: string
    phone: string
  }
  paymentMethod: string
  reference: string
}

const confirmedBooking = ref<ConfirmedBooking | null>(null)

const getPaymentMethodName = (method: string) => {
  const methods: Record<string, string> = {
    cashapp: 'CashApp',
    paypal: 'PayPal',
    zelle: 'Zelle',
    bitcoin: 'Bitcoin',
    applepay: 'Apple Pay'
  }
  return methods[method] || method
}

const downloadTicket = () => {
  alert('Ticket download feature coming soon! Your tickets have been emailed to you.')
}

onMounted(() => {
  const stored = sessionStorage.getItem('confirmedBooking')
  if (stored) {
    confirmedBooking.value = JSON.parse(stored)
    sessionStorage.removeItem('bookingData')
  }
})

useHead({
  title: 'Booking Confirmed - Russell Crowe Indoor Garden Party',
  meta: [
    { name: 'description', content: 'Your booking for Russell Crowe Indoor Garden Party has been confirmed' }
  ]
})
</script>
