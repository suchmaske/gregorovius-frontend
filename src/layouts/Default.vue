<template>
  <q-layout>
    <q-header :class="(($route.path === '/') ? 'transparent' : 'bg-primary')">
      <q-tabs inline-label indicator-color="positive" align="left">
        <img class="gt-sm logo-signature cursor-pointer q-mx-md q-pa-md" src="../statics/img/gregorovius_signature.svg" @click="$router.push({ path: '/' })"/>
        <q-icon class="lt-sm q-mr-md cursor-pointer" name="home" style="font-size: 1.3em" @click="$router.push({ path: '/' })"></q-icon>
        <q-route-tab to="/letters" label="BRIEFE" />
        <q-route-tab to="/persons" label="PERSONEN" />
        <q-route-tab to="/places" label="ORTE" />
        <q-route-tab to="/works" label="WERKE" />
        <q-space />
        <q-btn flat label="PROJEKT" @click="$router.push({name: 'Projekt'})"/>
        <q-btn flat label="TEAM" @click="$router.push({name: 'Team'})"/>
        <q-btn flat label="EDITIONSRICHTLINIEN" />
      </q-tabs>
    </q-header>
    <q-page-container :class="(($route.path === '/') ? 'bg-none' : 'bg-grey-2')">
      <router-view />
    </q-page-container>
    <q-footer :class="(($route.path === '/') ? 'transparent' : 'bg-secondary')" class="text-white">
      <q-toolbar>
        <q-toolbar-title>
          <div class="row q-pa-md">
            <div class="col-md-6 col-10 q-pa-md self-center">
              <a href="http://dhi-roma.it">
                <img src="../statics/img/logo_dhi.png"/>
              </a>
            </div>
            <div class="col-md-3 col-10 q-pa-md">
              <div class="text-caption">gefördert durch</div>
              <div class="row q-py-md">
                <a href="https://www.dfg.de/">
                  <img src="../statics/img/logo_dfg.png"/>
                </a>
              </div>
              <div class="row">
                <a href="https://www.gerda-henkel-stiftung.de/">
                  <img src="../statics/img/logo_henkel.png"/>
                </a>
              </div>
            </div>
            <div class="col-md-3 col-10 q-pa-md">
              <div class="text-caption">in Kooperation mit</div>
                <a href="http://www.bbaw.de">
                  <img src="../statics/img/logo_bbaw.png"/>
                </a>
              </div>
            </div>
            <div class="row">
              <div class="col-md-3 col-10 q-pa-md q-ml-sm">
                <div class="text-caption">
                  Impressum
                </div>
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
  max-width: 320px;
}
.q-tab__indicator {
  height: 5px !important;
}
</style>
