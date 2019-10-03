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
        <div class="text-h7 text-left text-white">Prof. Dr. Martin Baumeister und Dr. Angela Steinsiek</div>
      </div>
    </div>   
    <q-img class="landing-page fullscreen" style="z-index: -1">
    </q-img>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  name: 'PageIndex',
  methods: {
    ...mapActions(['loadLettersAction', 'loadFullNameIndexAction']),
  },
  async mounted () {
    await this.loadLettersAction();
    await this.loadFullNameIndexAction();
  },
}
</script>

<style>
@import url('https://fonts.googleapis.com/css?family=IBM+Plex+Sans:400,500,600,700&display=swap');

@keyframes breath {
  from { 
    transform: scale(1);
  }
  to {
    transform: scale(1.2)
  }
}

.landing-page {
  background: url('../statics/img/gregorovius-frommel-bsb.jpg') center center no-repeat;
  background-size: cover;
  background-attachment: fixed;
  animation: breath 30s ease-in-out alternate infinite;
}

.landing-page-text {
  font-family: 'IBM Plex Sans', sans-serif;
}

.landing-button {
  font-weight: bold !important;
}

</style>
