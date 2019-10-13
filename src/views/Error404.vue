<template>
  <div class="fixed-center text-center">
    <p class="text-faded">Hier ist leider nichts zu finden...<strong>(404)</strong></p>
    <q-btn
      color="secondary"
      style="width:200px;"
      @click="$router.go(-1)"
    >Zurück</q-btn>
  </div>
</template>

<script>
export default {
  name: 'Error404',
};
</script>
