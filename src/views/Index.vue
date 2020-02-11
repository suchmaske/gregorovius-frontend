<template>
  <div>
    <div class="col-12 landing-page-text q-gutter-xs q-pl-xl q-ml-xl q-py-xl">
      <div class="text-h4 text-left text-positive text-bold">Ferdinand Gregorovius</div>
      <div class="text-h4 text-left text-positive">Poesie und Wissenschaft</div>
      <div class="text-h4 text-left text-white text-bold">Gesammelte deutsche und italienische</div>
      <q-btn rounded no-caps color="primary" style="left: -5em" @click="$router.push('letters')">
        <q-icon left size="3em" name="arrow_right"></q-icon>
        <div class="text-center text-h4 landing-button">Briefe</div>
      </q-btn>
      <div class="row q-mt-lg">
        <div class="text-h7 text-left text-white text-bold q-pr-xs">Projektleitung</div>
        <div class="text-h7 text-left text-white">
          Prof. Dr. Martin Baumeister und Dr. Angela Steinsiek
        </div>
      </div>
      <div class="row q-mt-xl">
        <q-card
          class="bg-secondary text-white cursor-pointer"
          @click="
            openUrl(
              'https://application.dhi-roma.it/Jobs/Detail/9fd204bd-3410-4f16-bbd6-f76e2e891800'
            )
          "
        >
          <q-card-section>
            <div class="text-subtitle2">
              <q-icon name="work_outline" class="q-mr-md" style="font-size: 1.4em;" />Job: Wiss.
              Mitarbeiter/in Digital Humanities (m/w/d) 50%
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>
    <q-img class="landing-page fullscreen" style="z-index: -1"> </q-img>
  </div>
</template>

<script>
export default {
  name: "PageIndex",
  methods: {
    openUrl(url) {
      url ? window.open(url) : null;
    }
  }
};
</script>

<style>
@keyframes breath {
  from {
    transform: scale(1);
  }
  to {
    transform: scale(1.2);
  }
}

.landing-page {
  background: url("../statics/img/gregorovius-frommel-bsb.jpg") center center no-repeat;
  background-size: cover;
  background-attachment: fixed;
  animation: breath 30s ease-in-out alternate infinite;
}

.landing-page-text .text-bold {
  font-family: "IBMPlexSansBold";
  font-weight: normal;
}

.landing-button {
  font-family: "IBMPlexSansBold";
}
</style>
