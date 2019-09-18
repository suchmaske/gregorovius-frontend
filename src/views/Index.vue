<template>
  <div>
    <div class="q-md landing-page fullscreen" style="z-index: 0">
    </div>
    <div class="col-12 fixed-center landing-page-text q-gutter-xs">
      <div class="text-h4 text-left text-positive text-bold">Ferdinand Gregorovius</div>
      <div class="text-h4 text-left text-positive">Poesie und Wissenschaft</div>
      <div class="text-h4 text-left text-white text-bold">Gesammelte deutsche und italienische</div>
      <q-btn rounded no-caps color="primary" style="left: -5em" @click="$router.push('letters')">
        <q-icon left size="3em" name="arrow_right"></q-icon>
        <div class="text-center text-h4 landing-button">Briefe</div>
      </q-btn>
      <div class="text-h7 text-left text-white q-mt-md"><b>Projektleitung </b> Prof. Dr. Martin Baumeister und Dr. Angela Steinsiek</div>
    </div>   
  </div>
</template>

<script>
export default {
  name: 'PageIndex'
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
  top: 30% !important;
  left: 37% !important;
  width: auto !important;
}

.landing-button {
  font-weight: bold !important;

}

</style>
