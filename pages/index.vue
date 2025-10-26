<template>
  <div class="min-h-screen">
    <section
      class="relative min-h-screen flex items-center justify-center overflow-hidden"
    >
      <div
        class="absolute inset-0 bg-gradient-radial from-amber-950/20 via-gray-950 to-gray-950"
      ></div>
      <div class="absolute inset-0 opacity-10">
        <div
          class="absolute top-20 left-20 w-72 h-72 bg-amber-500 rounded-full filter blur-3xl"
        ></div>
        <div
          class="absolute bottom-20 right-20 w-96 h-96 bg-orange-600 rounded-full filter blur-3xl"
        ></div>
      </div>

      <div
        class="relative z-10 max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center"
      >
        <div
          class="inline-block mb-6 px-4 py-2 bg-amber-500/10 border border-amber-500/30 rounded-full"
        >
          <span class="text-amber-400 text-sm font-semibold tracking-wider"
            >EXCLUSIVE EVENT</span
          >
        </div>

        <h1
          class="text-5xl sm:text-7xl lg:text-8xl font-display font-bold mb-6 leading-tight"
        >
          <span class="text-gradient">Russell Crowe's</span>
          <br />
          <span class="text-white">Indoor Garden Party</span>
        </h1>

        <div
          class="flex flex-col sm:flex-row items-center justify-center gap-6 mb-10 text-lg text-gray-300"
        >
          <div class="flex items-center gap-2">
            <Icon name="mdi:calendar" class="text-amber-400 text-2xl" />
            <span>Saturday, December 20th</span>
          </div>
          <div class="hidden sm:block text-amber-400">•</div>
          <div class="flex items-center gap-2">
            <Icon name="mdi:clock-outline" class="text-amber-400 text-2xl" />
            <span>7:00 PM</span>
          </div>
          <div class="hidden sm:block text-amber-400">•</div>
          <div class="flex items-center gap-2">
            <Icon name="mdi:map-marker" class="text-amber-400 text-2xl" />
            <span>Enmore Theatre, Sydney</span>
          </div>
        </div>

        <NuxtLink to="/tickets" class="inline-block btn-primary text-xl">
          <span class="flex items-center gap-2">
            <Icon name="mdi:ticket" class="text-2xl" />
            Buy Tickets Now
          </span>
        </NuxtLink>

        <p class="mt-8 text-gray-400 max-w-2xl mx-auto">
          Join us for an unforgettable evening of music, entertainment, and
          elegance
        </p>
      </div>

      <div class="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce">
        <Icon name="mdi:chevron-down" class="text-amber-400 text-4xl" />
      </div>
    </section>

    <section class="py-20 px-4 sm:px-6 lg:px-8 bg-gray-900/50">
      <div class="max-w-6xl mx-auto">
        <h2 class="text-4xl font-display font-bold text-center mb-16">
          <span class="text-gradient">Event Highlights</span>
        </h2>

        <div class="grid md:grid-cols-3 gap-8">
          <div
            class="card hover:border-amber-500/50 transition-all duration-300 group"
          >
            <div
              class="text-amber-400 text-5xl mb-4 group-hover:scale-110 transition-transform"
            >
              <Icon name="mdi:music" />
            </div>
            <h3 class="text-2xl font-bold mb-3 text-white">Live Performance</h3>
            <p class="text-gray-400">
              Experience an intimate evening with Russell Crowe and special
              guests
            </p>
          </div>

          <div
            class="card hover:border-amber-500/50 transition-all duration-300 group"
          >
            <div
              class="text-amber-400 text-5xl mb-4 group-hover:scale-110 transition-transform"
            >
              <Icon name="mdi:glass-cocktail" />
            </div>
            <h3 class="text-2xl font-bold mb-3 text-white">
              Premium Experience
            </h3>
            <p class="text-gray-400">
              Enjoy curated cocktails and an elegant indoor garden atmosphere
            </p>
          </div>

          <div
            class="card hover:border-amber-500/50 transition-all duration-300 group"
          >
            <div
              class="text-amber-400 text-5xl mb-4 group-hover:scale-110 transition-transform"
            >
              <Icon name="mdi:star" />
            </div>
            <h3 class="text-2xl font-bold mb-3 text-white">
              VIP Opportunities
            </h3>
            <p class="text-gray-400">
              Meet & greet packages and exclusive backstage access available
            </p>
          </div>
        </div>
      </div>
    </section>

    <section class="py-20 px-4 sm:px-6 lg:px-8">
      <div class="max-w-6xl mx-auto">
        <h2 class="text-4xl font-display font-bold text-center mb-16">
          <span class="text-gradient">Venue Information</span>
        </h2>

        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h3 class="text-3xl font-bold text-white mb-4">Enmore Theatre</h3>
            <p class="text-gray-400 mb-6 leading-relaxed">
              The historic Enmore Theatre provides the perfect backdrop for this
              exclusive event. Built in 1908, this iconic Sydney venue combines
              classic elegance with modern amenities, creating an intimate
              setting for an unforgettable night.
            </p>
            <div class="space-y-4">
              <div class="flex items-start gap-3">
                <Icon
                  name="mdi:map-marker"
                  class="text-amber-400 text-xl mt-1"
                />
                <div>
                  <p class="text-white font-semibold">Address</p>
                  <p class="text-gray-400">130 Enmore Road, Newtown NSW 2042</p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <Icon name="mdi:parking" class="text-amber-400 text-xl mt-1" />
                <div>
                  <p class="text-white font-semibold">Parking</p>
                  <p class="text-gray-400">
                    Street parking available, public transport recommended
                  </p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <Icon name="mdi:train" class="text-amber-400 text-xl mt-1" />
                <div>
                  <p class="text-white font-semibold">Transport</p>
                  <p class="text-gray-400">5 min walk from Newtown Station</p>
                </div>
              </div>
            </div>
          </div>

          <div class="card overflow-hidden">
            <div class="aspect-video w-full h-full rounded-lg">
              <iframe
                width="100%"
                height="100%"
                style="border: 0"
                loading="lazy"
                allowfullscreen
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3311.654063808417!2d151.1741742!3d-33.898321799999996!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6b12b1c1b2c5c8fb%3A0x3b7e846a77b7481d!2sEnmore%20Theatre!5e0!3m2!1sen!2sus!4v1669852832873!5m2!1sen!2sus"
              ></iframe>
            </div>
            <a
              href="https://maps.google.com/?q=130+Enmore+Road,+Newtown+NSW+2042,+Australia"
              target="_blank"
              rel="noopener noreferrer"
              class="flex items-center justify-center gap-2 mt-4 text-amber-400 hover:text-amber-300 transition-colors"
            >
              <Icon name="mdi:open-in-new" class="text-lg" />
              <span>Open in Google Maps</span>
            </a>
          </div>
        </div>
      </div>
    </section>

    <section
      class="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-b from-gray-900/50 to-gray-950"
    >
      <div class="max-w-4xl mx-auto text-center">
        <h2 class="text-4xl font-display font-bold mb-6">
          <span class="text-gradient">Ready to Join Us?</span>
        </h2>
        <p class="text-gray-400 text-lg mb-10">
          Limited tickets available. Secure your spot for this exclusive event.
        </p>
        <NuxtLink to="/tickets" class="btn-primary text-xl">
          <span class="flex items-center gap-2">
            <Icon name="mdi:ticket" class="text-2xl" />
            Get Your Tickets
          </span>
        </NuxtLink>
      </div>
    </section>

    <footer class="border-t border-gray-800 py-8 px-4">
      <div class="max-w-6xl mx-auto text-center text-gray-500 text-sm">
        <p>
          &copy; 2025 Russell Crowe's Indoor Garden Party. All rights reserved.
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
useHead({
  title: "Russell Crowe's Indoor Garden Party - December 20th | Enmore Theatre",
  meta: [
    {
      name: "description",
      content:
        "Join Russell Crowe for an exclusive Indoor Garden Party at Enmore Theatre, Sydney on December 20th. Limited tickets available.",
    },
  ],
});
</script>
