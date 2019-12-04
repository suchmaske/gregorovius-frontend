<template>
  <q-page padding>
    <div class="row justify-center">
      <div class="col-md-8 col-12 q-py-xl q-gutter-y-lg">
        <q-card class="q-pa-xl" flat>
          <q-card-section>
            <div class="text-h6">{{ name }}</div>
            <div
              v-if="data.person.birth || data.person.death"
              class="text-subtitle3 text-secondary"
            >
              {{ data.person.birth }} - {{ data.person.death }}
            </div>
          </q-card-section>
          <q-separator dark />
        </q-card>
      </div>
    </div>
    <div class="row justify-center">
      <div class="col-md-8 col-12 q-pb-xl q-gutter-y-lg">
        <MentionsTable :entity-id="this.$route.params.id" :entity-name="name" />
      </div>
    </div>
  </q-page>
</template>

<script>
import { mapActions } from "vuex";
import MentionsTable from "@/components/MentionsTable";
import { API } from "@/shared/config";

export default {
  name: "PersonsDetail",
  components: { MentionsTable },
  data() {
    return {
      data: {
        person: {
          persName: "",
          birth: "",
          death: ""
        }
      }
    };
  },

  computed: {
    fullNameIndex() {
      return this.$store.getters.fullNameIndex;
    },
    name() {
      return this.fullNameIndex[this.$route.params.id];
    }
  },

  mounted() {
    if (this.$store.getters.fullNameIndex.length == 0) {
      this.loadFullNameIndexAction();
    }
    this.getItems();
  },

  methods: {
    ...mapActions(["loadLettersAction", "loadFullNameIndexAction"]),
    async getItems() {
      try {
        const response = await fetch(`${API}${this.$route.path}`, {
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
