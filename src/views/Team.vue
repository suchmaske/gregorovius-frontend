<template>
  <q-page padding>
    <div class="row justify-center">
        <div class="col-8 q-py-xl q-gutter-y-lg">
          <q-card class="col-md-8 col-12 q-pa-xl" flat>
            <q-card-section>
              <div class="text-h6 text-center">Das Team</div>
              <div class="text-subtitle3 text-secondary"></div>
            </q-card-section>
            <q-separator dark />
            <q-tabs v-model="tab" class="text-primary">
              <q-tab name="edi" />
              <q-tab name="tec" />
            </q-tabs>
            <q-separator />
            <q-tab-panels v-model="tab" animated>
              <q-tab-panel name="edi">
              </q-tab-panel>
              <q-tab-panel name="tec">
              </q-tab-panel>
            </q-tab-panels>
          </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: 'Project',
  data () {
    return {}
  },

}
</script>

<style>
</style>
