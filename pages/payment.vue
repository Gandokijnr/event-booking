<template>
  <div class="min-h-screen py-20 px-4 sm:px-6 lg:px-8">
    <div class="max-w-4xl mx-auto">
      <div class="text-center mb-12">
        <h1 class="text-5xl font-display font-bold mb-4">
          <span class="text-gradient">Payment Details</span>
        </h1>
        <p class="text-gray-400 text-lg">Complete your booking</p>
      </div>

      <div v-if="!bookingData" class="card text-center py-12">
        <Icon name="mdi:alert-circle" class="text-6xl text-amber-400 mb-4 mx-auto" />
        <p class="text-xl text-gray-400 mb-6">No booking data found</p>
        <NuxtLink to="/tickets" class="btn-primary">
          Select Tickets
        </NuxtLink>
      </div>

      <div v-else class="grid lg:grid-cols-2 gap-8">
        <div>
          <div class="card mb-6">
            <h2 class="text-2xl font-bold text-white mb-6 flex items-center gap-2">
              <Icon name="mdi:receipt" class="text-amber-400" />
              Order Summary
            </h2>

            <div class="space-y-3 mb-6">
              <div
                v-for="ticket in bookingData.tickets"
                :key="ticket.id"
                class="flex justify-between items-center py-3 border-b border-gray-800"
              >
                <div>
                  <span class="text-white font-semibold">{{ ticket.name }}</span>
                  <span class="text-gray-400 ml-2">x{{ ticket.quantity }}</span>
                </div>
                <span class="text-amber-400 font-semibold">${{ (ticket.price * ticket.quantity).toFixed(2) }}</span>
              </div>
            </div>

            <div class="flex justify-between items-center text-2xl font-bold pt-4 border-t border-gray-700">
              <span class="text-white">Total</span>
              <span class="text-gradient">${{ bookingData.total.toFixed(2) }}</span>
            </div>
          </div>

          <div class="card">
            <h2 class="text-2xl font-bold text-white mb-6 flex items-center gap-2">
              <Icon name="mdi:account" class="text-amber-400" />
              Your Information
            </h2>

            <form @submit.prevent class="space-y-4">
              <div>
                <label class="block text-gray-400 mb-2">Full Name *</label>
                <input
                  v-model="customerInfo.name"
                  type="text"
                  required
                  class="input-field"
                  placeholder="John Doe"
                />
              </div>

              <div>
                <label class="block text-gray-400 mb-2">Email Address *</label>
                <input
                  v-model="customerInfo.email"
                  type="email"
                  required
                  class="input-field"
                  placeholder="john@example.com"
                />
              </div>

              <div>
                <label class="block text-gray-400 mb-2">Phone Number</label>
                <input
                  v-model="customerInfo.phone"
                  type="tel"
                  class="input-field"
                  placeholder="+61 400 000 000"
                />
              </div>
            </form>
          </div>
        </div>

        <div>
          <div class="card">
            <h2 class="text-2xl font-bold text-white mb-6 flex items-center gap-2">
              <Icon name="mdi:credit-card" class="text-amber-400" />
              Payment Method
            </h2>

            <div class="grid grid-cols-2 gap-4 mb-8">
              <button
                v-for="method in paymentMethods"
                :key="method.id"
                @click="selectedPaymentMethod = method.id"
                class="card p-6 hover:border-amber-500/50 transition-all cursor-pointer"
                :class="{
                  'ring-2 ring-amber-500 border-amber-500': selectedPaymentMethod === method.id
                }"
              >
                <Icon :name="method.icon" class="text-4xl mb-3 mx-auto" :class="method.color" />
                <p class="text-white font-semibold text-center">{{ method.name }}</p>
              </button>
            </div>

            <div v-if="selectedPaymentMethod" class="bg-gray-800/50 rounded-lg p-6 mb-6">
              <h3 class="text-lg font-semibold text-white mb-4 flex items-center gap-2">
                <Icon name="mdi:information" class="text-amber-400" />
                Payment Instructions
              </h3>

              <div v-if="selectedPaymentMethod === 'cashapp'" class="space-y-3">
                <p class="text-gray-300">Send payment to:</p>
                <div class="bg-gray-900 rounded-lg p-4 font-mono text-amber-400 text-center text-xl">
                  $RussellCroweEvents
                </div>
                <p class="text-gray-400 text-sm">Include your name in the payment note</p>
              </div>

              <div v-else-if="selectedPaymentMethod === 'paypal'" class="space-y-3">
                <p class="text-gray-300">Send payment to:</p>
                <div class="bg-gray-900 rounded-lg p-4 font-mono text-amber-400 text-center text-xl break-all">
                  payments@russellcroweevents.com
                </div>
                <p class="text-gray-400 text-sm">Or use PayPal.me/RussellCroweEvents</p>
              </div>

              <div v-else-if="selectedPaymentMethod === 'zelle'" class="space-y-3">
                <p class="text-gray-300">Send payment to:</p>
                <div class="bg-gray-900 rounded-lg p-4 font-mono text-amber-400 text-center text-xl break-all">
                  events@russellcrowe.com
                </div>
                <p class="text-gray-400 text-sm">Phone: +61 400 123 456</p>
              </div>

              <div v-else-if="selectedPaymentMethod === 'bitcoin'" class="space-y-3">
                <p class="text-gray-300">Bitcoin Wallet Address:</p>
                <div class="bg-gray-900 rounded-lg p-4 font-mono text-amber-400 text-center text-sm break-all">
                  bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh
                </div>
                <div class="bg-white p-4 rounded-lg mx-auto w-48 h-48 flex items-center justify-center">
                  <Icon name="mdi:qrcode" class="text-gray-900 text-full" />
                </div>
                <p class="text-gray-400 text-sm text-center">Scan QR code with your Bitcoin wallet</p>
              </div>

              <div v-else-if="selectedPaymentMethod === 'applepay'" class="space-y-3">
                <p class="text-gray-300 text-center mb-4">
                  Click the button below to complete payment with Apple Pay
                </p>
                <button class="w-full bg-black hover:bg-gray-900 text-white font-semibold py-4 rounded-lg transition-all flex items-center justify-center gap-2">
                  <Icon name="mdi:apple" class="text-2xl" />
                  Pay with Apple Pay
                </button>
                <p class="text-gray-400 text-sm text-center">Available on Safari and iOS devices</p>
              </div>
            </div>

            <div v-if="selectedPaymentMethod" class="space-y-4">
              <div class="flex items-start gap-3">
                <input
                  v-model="agreedToTerms"
                  type="checkbox"
                  id="terms"
                  class="mt-1 w-5 h-5 bg-gray-800 border-gray-700 rounded focus:ring-amber-500"
                />
                <label for="terms" class="text-gray-300 text-sm">
                  I agree to the terms and conditions and confirm that I will complete the payment using the selected method
                </label>
              </div>

              <button
                @click="confirmBooking"
                :disabled="!canConfirm || processing"
                class="w-full btn-primary text-lg"
                :class="{ 'opacity-50 cursor-not-allowed': !canConfirm || processing }"
              >
                <span v-if="processing" class="flex items-center justify-center gap-2">
                  <Icon name="mdi:loading" class="text-2xl animate-spin" />
                  Processing...
                </span>
                <span v-else class="flex items-center justify-center gap-2">
                  <Icon name="mdi:check-circle" class="text-2xl" />
                  Confirm Booking
                </span>
              </button>

              <p class="text-gray-400 text-sm text-center">
                You will receive a confirmation email with your booking details
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabase()
const router = useRouter()

interface BookingData {
  tickets: Array<{
    id: string
    name: string
    price: number
    quantity: number
  }>
  total: number
}

const bookingData = ref<BookingData | null>(null)
const selectedPaymentMethod = ref<string>('')
const agreedToTerms = ref(false)
const processing = ref(false)

const customerInfo = ref({
  name: '',
  email: '',
  phone: ''
})

const paymentMethods = [
  { id: 'cashapp', name: 'CashApp', icon: 'mdi:cash', color: 'text-green-400' },
  { id: 'paypal', name: 'PayPal', icon: 'mdi:paypal', color: 'text-blue-400' },
  { id: 'zelle', name: 'Zelle', icon: 'mdi:bank', color: 'text-purple-400' },
  { id: 'bitcoin', name: 'Bitcoin', icon: 'mdi:bitcoin', color: 'text-orange-400' },
  { id: 'applepay', name: 'Apple Pay', icon: 'mdi:apple', color: 'text-gray-300' }
]

const canConfirm = computed(() => {
  return (
    customerInfo.value.name.trim() !== '' &&
    customerInfo.value.email.trim() !== '' &&
    selectedPaymentMethod.value !== '' &&
    agreedToTerms.value
  )
})

const generateBookingReference = () => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  let result = 'RC'
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return result
}

const confirmBooking = async () => {
  if (!canConfirm.value || !bookingData.value) return

  processing.value = true

  try {
    const bookingReference = generateBookingReference()

    for (const ticket of bookingData.value.tickets) {
      const { error } = await supabase
        .from('bookings')
        .insert({
          customer_name: customerInfo.value.name,
          customer_email: customerInfo.value.email,
          customer_phone: customerInfo.value.phone,
          ticket_type_id: ticket.id,
          quantity: ticket.quantity,
          total_amount: ticket.price * ticket.quantity,
          payment_method: selectedPaymentMethod.value,
          payment_status: 'pending',
          booking_reference: bookingReference
        })

      if (error) {
        console.error('Booking error:', error)
        alert('An error occurred while creating your booking. Please try again.')
        processing.value = false
        return
      }
    }

    sessionStorage.setItem('confirmedBooking', JSON.stringify({
      ...bookingData.value,
      customerInfo: customerInfo.value,
      paymentMethod: selectedPaymentMethod.value,
      reference: bookingReference
    }))

    router.push('/confirmation')
  } catch (error) {
    console.error('Error:', error)
    alert('An unexpected error occurred. Please try again.')
  } finally {
    processing.value = false
  }
}

onMounted(() => {
  const stored = sessionStorage.getItem('bookingData')
  if (stored) {
    bookingData.value = JSON.parse(stored)
  }
})

useHead({
  title: 'Payment - Russell Crowe Indoor Garden Party',
  meta: [
    { name: 'description', content: 'Complete your booking for Russell Crowe Indoor Garden Party' }
  ]
})
</script>
