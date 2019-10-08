<template>
<q-page padding>
<div class="row justify-center">
  <div class="col-md-8 col-12 q-py-xl q-gutter-y-lg">
    <q-card class="q-pa-xl" flat>
      <q-card-section>
        <div class="text-h6">Werkregister</div>
      </q-card-section>
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
          <works-index-table :data="this.gregoroviusMain"/>
        </q-tab-panel>
        <q-tab-panel name="ueb">
          <works-index-table :data="this.gregoroviusTranslations"/>
        </q-tab-panel>
        <q-tab-panel name="waa">
          <works-index-table :data="this.othersMain"/>
        </q-tab-panel>
        <q-tab-panel name="zgq">
          <works-index-table :data="this.contemporarySources"/>
        </q-tab-panel>
        <q-tab-panel name="skl">
          <works-index-table :data="this.secondary"/>
        </q-tab-panel>
      </q-tab-panels>
    </q-card>
  </div>
</div>
</q-page>
</template>

<script>
import WorksIndexTable from '@/components/WorksIndexTable'
import { mapActions, mapState } from 'vuex';

export default {
  name: 'items-list',
  components: {WorksIndexTable},
  data() {
    return {
      tab: "wgr",
      data: []
    }
  },
  mounted() {
    this.getItems();
  },
  methods: {
    ...mapActions(['setLoadingStatus']),
    async getItems() {
      this.setLoadingStatus(true);
      try {
        const response = await fetch(`http://localhost:8000${this.$route.path}`);
        const data = await response.json();
        this.data = data;
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
      this.setLoadingStatus(false);
    },
  },

  computed: {
    gregoroviusMain () {
      return this.data.filter(w => w.properties.type == "gregoroviusMain")
    },
    othersMain () {
      return this.data.filter(w => w.properties.type == "othersMain")
    },
    gregoroviusTranslations () {
      return this.data.filter(w => w.properties.type == "gregoroviusTranslation")
    },
    contemporarySources () {
      return this.data.filter(w => w.properties.type == "contemporarySources")
    },
    secondary () {
      return this.data.filter(w => w.properties.type == "secondary")
    },
  }

};
</script>

<style>
</style>
