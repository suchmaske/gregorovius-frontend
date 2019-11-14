<template>
  <q-page padding>
    <div class="col-8 q-pa-xl q-gutter-y-lg">
      <q-card class="col-md-8 col-12 q-pa-xl" flat bordered>
        <q-card-section>
          <div class="text-h6"></div>
          <div class="text-subtitle3 text-secondary"></div>
          <a :href="'http://localhost:8000' + this.$route.path">
            <q-icon name="code" class="text-primary float-right" style="font-size: 2em;" />
          </a>
        </q-card-section>
        <q-separator dark />
      </q-card>

      <q-card class="col-md-8 col-12 q-pa-xl" flat bordered>
        <LettersText />
      </q-card>
    </div>
  </q-page>
</template>

<script>
export default {
  name: "InstitutionsDetail",
  data() {
    return {
      data: [],
      tab: "hsf"
    };
  },
  computed: {},

  mounted() {
    this.getItems();
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(`http://localhost:8000${this.$route.path}`, {
          headers: { Accept: "application/json" }
        });
        const data = await response.json();
        this.data = data;
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    }
  }
};
</script>

<style></style>
