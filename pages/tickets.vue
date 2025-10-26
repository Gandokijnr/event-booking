<template>
  <div class="min-h-screen py-20 px-4 sm:px-6 lg:px-8">
    <div class="max-w-7xl mx-auto">
      <div class="text-center mb-16">
        <NuxtLink
          to="/"
          class="inline-flex items-center gap-2 text-amber-400 hover:text-amber-300 mb-6 transition-colors"
        >
          <Icon name="mdi:arrow-left" />
          Back to Home
        </NuxtLink>
        <h1 class="text-5xl font-display font-bold mb-4">
          <span class="text-gradient">Choose Your Experience</span>
        </h1>
        <p class="text-gray-400 text-lg">
          Select your preferred ticket tier and secure your spot
        </p>
      </div>

      <div v-if="loading" class="text-center py-20">
        <Icon name="mdi:loading" class="text-6xl text-amber-400 animate-spin" />
      </div>

      <div v-else class="grid md:grid-cols-3 gap-8 mb-16">
        <div
          v-for="ticket in ticketTypes"
          :key="ticket.id"
          class="card relative hover:border-amber-500/50 transition-all duration-300"
          :class="{
            'ring-2 ring-amber-500 border-amber-500': ticket.name === 'VIP',
          }"
        >
          <div
            v-if="ticket.name === 'VIP'"
            class="absolute -top-4 left-1/2 -translate-x-1/2"
          >
            <span
              class="bg-gradient-to-r from-amber-500 to-orange-600 text-white text-xs font-bold px-4 py-1 rounded-full"
            >
              POPULAR
            </span>
          </div>

          <div class="text-center mb-6">
            <h3 class="text-3xl font-bold text-white mb-2">
              {{ ticket.name }}
            </h3>
            <div class="text-5xl font-bold text-gradient mb-2">
              ${{ ticket.price }}
            </div>
            <p class="text-gray-400 text-sm">per person</p>
          </div>

          <p class="text-gray-400 mb-6 text-center">{{ ticket.description }}</p>

          <ul class="space-y-3 mb-8">
            <li
              v-for="(feature, index) in ticket.features"
              :key="index"
              class="flex items-start gap-3 text-gray-300"
            >
              <Icon
                name="mdi:check-circle"
                class="text-amber-400 text-xl flex-shrink-0 mt-0.5"
              />
              <span>{{ feature }}</span>
            </li>
          </ul>

          <div class="space-y-4">
            <div class="flex items-center justify-between gap-4">
              <label class="text-gray-400">Quantity:</label>
              <div class="flex items-center gap-2">
                <button
                  @click="decrementQuantity(ticket.id)"
                  class="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center transition-colors"
                  :disabled="
                    !selectedTickets[ticket.id] ||
                    selectedTickets[ticket.id] === 0
                  "
                >
                  <Icon name="mdi:minus" class="text-xl" />
                </button>
                <span class="w-12 text-center text-xl font-semibold text-white">
                  {{ selectedTickets[ticket.id] || 0 }}
                </span>
                <button
                  @click="incrementQuantity(ticket.id)"
                  class="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center transition-colors"
                  :disabled="
                    getRemainingTickets(ticket) === 0 ||
                    (selectedTickets[ticket.id] || 0) >=
                      (ticket.name === 'Membership Card'
                        ? 1
                        : ticket.name === 'VIP'
                        ? 2
                        : ticket.name === 'Meet after event'
                        ? 2
                        : 4)
                  "
                >
                  <Icon name="mdi:plus" class="text-xl" />
                </button>
              </div>
            </div>

            <div class="text-center text-sm">
              <span
                :class="
                  getRemainingTickets(ticket) > 10
                    ? 'text-green-400'
                    : 'text-orange-400'
                "
              >
                {{ getRemainingTickets(ticket) }} tickets remaining
              </span>
            </div>
          </div>
        </div>
      </div>

      <div v-if="totalAmount > 0" class="card max-w-2xl mx-auto">
        <h3 class="text-2xl font-bold text-white mb-6 text-center">
          Booking Summary
        </h3>

        <div class="space-y-3 mb-6">
          <div
            v-for="ticket in selectedTicketDetails"
            :key="ticket.id"
            class="flex justify-between items-center py-3 border-b border-gray-800"
          >
            <div>
              <span class="text-white font-semibold">{{ ticket.name }}</span>
              <span class="text-gray-400 ml-2">x{{ ticket.quantity }}</span>
            </div>
            <span class="text-amber-400 font-semibold"
              >${{ (ticket.price * ticket.quantity).toFixed(2) }}</span
            >
          </div>
        </div>

        <div
          class="flex justify-between items-center text-2xl font-bold pt-4 border-t border-gray-700"
        >
          <span class="text-white">Total</span>
          <span class="text-gradient">${{ totalAmount.toFixed(2) }}</span>
        </div>

        <!-- Payment Methods -->
        <div class="mt-8">
          <h4 class="text-lg font-semibold text-white mb-4">
            Select Payment Method
          </h4>
          <div class="grid grid-cols-3 gap-4">
            <button
              v-for="method in paymentMethods"
              :key="method.id"
              @click="selectedPaymentMethod = method.id"
              class="flex flex-col items-center justify-center p-4 rounded-lg border transition-all duration-300"
              :class="
                selectedPaymentMethod === method.id
                  ? 'border-amber-500 bg-amber-500/10'
                  : 'border-gray-800 hover:border-gray-700'
              "
            >
              <Icon
                :name="method.icon"
                class="text-2xl mb-2"
                :class="method.iconColor"
              />
              <span class="text-sm text-gray-400">{{ method.name }}</span>
            </button>
          </div>
        </div>

        <button
          @click="proceedToPayment"
          :disabled="!selectedPaymentMethod"
          class="w-full btn-primary mt-8 text-lg disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span class="flex items-center justify-center gap-2">
            <Icon name="mdi:credit-card" class="text-2xl" />
            Proceed to Payment
          </span>
        </button>
      </div>

      <div v-else class="text-center text-gray-400 py-12">
        <Icon name="mdi:ticket-outline" class="text-6xl mb-4 mx-auto" />
        <p class="text-xl">Select tickets to continue</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabase();
const router = useRouter();

interface TicketType {
  id: string;
  name: string;
  price: number;
  quantity: number;
  description: string;
  features?: string[];
  total_quantity?: number;
  sold_quantity?: number;
  available_quantity?: number;
}

const paymentMethods = [
  {
    id: "cashapp",
    name: "Cash App",
    icon: "simple-icons:cashapp",
    iconColor: "text-green-500",
  },
  {
    id: "paypal",
    name: "PayPal",
    icon: "simple-icons:paypal",
    iconColor: "text-blue-500",
  },
  {
    id: "zelle",
    name: "Zelle",
    icon: "material-symbols:payments-rounded",
    iconColor: "text-purple-500",
  },
  {
    id: "bitcoin",
    name: "Bitcoin",
    icon: "mdi:bitcoin",
    iconColor: "text-amber-500",
  },
  {
    id: "applepay",
    name: "Apple Pay",
    icon: "mdi:apple",
    iconColor: "text-white",
  },
];

const ticketTypes = ref<TicketType[]>([]);
const selectedTickets = ref<Record<string, number>>({});
const selectedPaymentMethod = ref<string | null>(null);
const loading = ref(true);

const totalAmount = computed(() => {
  return ticketTypes.value.reduce((total, ticket) => {
    const quantity = selectedTickets.value[ticket.id] || 0;
    return total + ticket.price * quantity;
  }, 0);
});

const selectedTicketDetails = computed(() => {
  return ticketTypes.value
    .filter((ticket) => selectedTickets.value[ticket.id] > 0)
    .map((ticket) => ({
      ...ticket,
      quantity: selectedTickets.value[ticket.id],
    }));
});

const getTicketDescription = (ticketType: string) => {
  switch (ticketType) {
    case "Meet after event":
      return "Exclusive opportunity to meet after the event with special access";
    case "Regular":
      return "Standard event access with comfortable seating";
    case "VIP":
      return "Premium seating with enhanced event experience";
    case "Membership Card":
      return "Premium membership card with exclusive year-round benefits";
    default:
      return "";
  }
};

const getRemainingTickets = (ticket: TicketType) => {
  return ticket.available_quantity || 0;
};

const fetchTickets = async () => {
  loading.value = true;
  const { data, error } = await supabase
    .from("available_tickets")
    .select(
      `
      id,
      event_id,
      ticket_type,
      price,
      total_quantity,
      sold_quantity,
      available_quantity
    `
    )
    .order("price", { ascending: true });

  if (!error && data) {
    ticketTypes.value = data.map((ticket) => ({
      id: ticket.id,
      name: ticket.ticket_type,
      price: ticket.price,
      quantity: ticket.total_quantity,
      total_quantity: ticket.total_quantity,
      sold_quantity: ticket.sold_quantity,
      available_quantity: ticket.available_quantity,
      description: getTicketDescription(ticket.ticket_type),
    }));
  }
  loading.value = false;
};

const incrementQuantity = (ticketId: string) => {
  const ticket = ticketTypes.value.find((t) => t.id === ticketId);
  if (!ticket) return;

  const availableQuantity = ticket.available_quantity || 0;
  const current = selectedTickets.value[ticketId] || 0;
  const maxPerOrder =
    ticket.name === "Membership Card"
      ? 1
      : ticket.name === "VIP"
      ? 2
      : ticket.name === "Meet after event"
      ? 2
      : 4;

  if (current < availableQuantity && current < maxPerOrder) {
    selectedTickets.value[ticketId] = current + 1;
  }
};

const decrementQuantity = (ticketId: string) => {
  const current = selectedTickets.value[ticketId] || 0;
  if (current > 0) {
    selectedTickets.value[ticketId] = current - 1;
  }
};

const generateWhatsAppMessage = () => {
  let message =
    "Hello! I would like to purchase tickets for Russell Crowe's Indoor Garden Party:\n\n";

  selectedTicketDetails.value.forEach((ticket) => {
    message += `${ticket.name}: ${ticket.quantity} × $${ticket.price} = $${(
      ticket.quantity * ticket.price
    ).toFixed(2)}\n`;
  });

  message += `\nTotal Amount: $${totalAmount.value.toFixed(2)}\n`;
  message += `Payment Method: ${selectedPaymentMethod.value?.toUpperCase()}\n\n`;
  message += "Please provide payment details to proceed with the purchase.";

  return encodeURIComponent(message);
};

const proceedToPayment = () => {
  if (!selectedPaymentMethod.value) {
    return;
  }

  const phoneNumber = "15754192465";
  const message = generateWhatsAppMessage();
  const whatsappUrl = `https://wa.me/${phoneNumber}?text=${message}`;

  // Open WhatsApp in a new tab
  window.open(whatsappUrl, "_blank");
};

onMounted(() => {
  fetchTickets();
});

useHead({
  title: "Select Tickets - Russell Crowe Indoor Garden Party",
  meta: [
    {
      name: "description",
      content:
        "Choose your ticket tier for Russell Crowe Indoor Garden Party. Regular, VIP, and VVIP options available.",
    },
  ],
});
</script>
