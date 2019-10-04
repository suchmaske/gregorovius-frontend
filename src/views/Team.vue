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
          </q-card>
            <q-card v-for="person in team" :item="person" :key="person.id" @click="openUrl(person.url)" :class="person.url ? 'cursor-pointer g-person' : 'g-person'">
              <img src="">
              <q-card-section>
                <div class="text-h6">{{ person.name }}</div>
                <div class="text-subtitle2 text-primary">{{ person.role }}</div>
                <div class="text-secondary">{{ person.mail }}</div>
                <div class="text-secondary">{{ person.tel }}</div>
              </q-card-section>
            </q-card>
        </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: 'Project',
  data () {
    return {
      team: [
        {
          id: "steinsiek",
          name: "Dr. Angela Steinsiek",
          role: "Projekt- und Editionsleitung (DFG-Projekt)",
          tel: "+49 (0)30 4940204",
          mail: "steinsiek@dhi-roma.it",
          url: "http://dhi-roma.it/index.php?id=steinsiek"
        },
        {
          id: "costea",
          name: "Theodor Costea M. A.",
          role: "Wissenschaftlicher Mitarbeiter (DFG-Projekt)",
          tel: "+49 (0)30 20370490",
          mail: "costea@dhi-roma.it",
          url: "http://dhi-roma.it/index.php?id=costea"
        },
        {
          id: "weiger",
          name: "Dr. des. Katharina Weiger",
          role: "Wissenschaftliche Mitarbeiterin (Stipendiatin Gerda Henkel Stiftung)",
          tel: "+49 (0)7571 7572970",
          mail: "weiger@dhi-roma.it",
          url: "http://dhi-roma.it/index.php?id=fastenrath-vinattieri0"
        },
        {
          id: "stepken",
          name: "Raphael Stepken B. A.",
          role: "Wissenschaftliche Hilfskraft (DFG-Projekt)",
          tel: "",
          mail: "stepken@dhi-roma.it",
        },
      ]
    }
    
  },
  methods: {
    openUrl (url) {
      url ? window.open(url) : null
    }
  }

}
</script>

<style>
.g-person {
  width: 100%;
}
</style>
