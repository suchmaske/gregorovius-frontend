<template>
  <q-page padding>
    <div class="q-pa-md">
      <q-card class="q-pa-xl" flat>
        <q-separator dark />
        <q-tabs v-model="tab" class="text-primary">
          <q-tab label="Werkregister Gregorovius" name="wgr" />
          <q-tab label="Übersetzungen" name="ueb" />
          <q-tab label="Werke anderer Autoren" name="waa" />
          <q-tab label="Zeitgenössische Quellen" name="zgq" />
          <q-tab label="Sekundärliteratur" name="skl" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab" animated>
          <q-tab-panel name="wgr">
            <works-index-table :data="gregoroviusMain" />
          </q-tab-panel>
          <q-tab-panel name="ueb">
            <works-index-table :data="gregoroviusTranslations" />
          </q-tab-panel>
          <q-tab-panel name="waa">
            <works-index-table :data="othersMain" />
          </q-tab-panel>
          <q-tab-panel name="zgq">
            <works-index-table :data="contemporarySources" />
          </q-tab-panel>
          <q-tab-panel name="skl">
            <works-index-table :data="secondary" />
          </q-tab-panel>
        </q-tab-panels>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { mapActions } from "vuex";
import WorksIndexTable from "@/components/WorksIndexTable";
import { API } from "@/shared/config";

export default {
  name: "ItemsList",
  components: { WorksIndexTable },
  data() {
    return {
      tab: "wgr",
      data: []
    };
  },
  computed: {
    gregoroviusMain() {
      return this.data.filter(w => w.properties.type == "gregoroviusMain");
    },
    othersMain() {
      return this.data.filter(w => w.properties.type == "othersMain");
    },
    gregoroviusTranslations() {
      return this.data.filter(w => w.properties.type == "gregoroviusTranslation");
    },
    contemporarySources() {
      return this.data.filter(w => w.properties.type == "contemporarySources");
    },
    secondary() {
      return this.data.filter(w => w.properties.type == "secondary");
    }
  },
  mounted() {
    this.getItems();
  },
  methods: {
    ...mapActions(["setLoadingStatus"]),
    async getItems() {
      this.setLoadingStatus(true);
      try {
        const response = await fetch(`${API}${this.$route.path}`);
        const data = await response.json();
        this.data = data;
      } catch (error) {
        console.error(error);
      }
      this.setLoadingStatus(false);
    }
  }
};
</script>

<style></style>
