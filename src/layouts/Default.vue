<template>
  <q-layout>
    <q-header  :class="(($route.path === '/') ? 'transparent' : 'bg-primary')">
      <q-tabs inline-label indicator-color="grey-1" align="left">
        <img class="gt-sm logo-signature cursor-pointer q-mx-md q-pa-md" src="../statics/img/gregorovius_signature.svg" @click="$router.push({ path: '/' })"/>
        <q-route-tab to="/letters" label="BRIEFE" />
        <q-route-tab to="/persons" label="PERSONEN" />
        <q-route-tab to="/institutions" label="KÖRPERSCHAFTEN" />
        <q-route-tab to="/places" label="ORTE" />
        <q-route-tab to="/works" label="WERKE" />
        <q-space />
        <q-btn flat label="EDITIONSRICHTLINIEN" />
        <q-btn flat label="PROJEKT" />
      </q-tabs>
    </q-header>
    <q-page-container class="bg-grey-1 q-py-none">
      <router-view />
    </q-page-container>
    <q-footer :class="(($route.path === '/') ? 'transparent' : 'bg-secondary')" class="text-white">
      <q-toolbar>
        <q-toolbar-title>
          <div class="row q-pa-md">
            <div class="col-md-6 col-10 q-pa-md self-center">
              <div class="row">
                <img src="../statics/img/logo_dhi.png"/>
              </div>
            </div>
            <div class="col-md-3 col-10 q-pa-md">
              <div class="text-caption">gefördert durch</div>
              <div class="row q-py-md">
                <img src="../statics/img/logo_dfg.png"/>
              </div>
              <div class="row">
                <img src="../statics/img/logo_henkel.png"/>
              </div>
            </div>
            <div class="col-md-3 col-10 q-pa-md">
              <div class="row">
                <div class="text-caption">in Kooperation mit</div>
                <img src="../statics/img/logo_bbaw.png"/>
              </div>
            </div>
          </div>
        </q-toolbar-title>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script>
export default {
  name: 'DefaultLayout',
}
</script>

<style>
.landing-page-bg {
  color: none;
}
.logo-signature {
  height: 80px;
}
.q-tab__indicator {
  height: 5px !important;
}
</style>
