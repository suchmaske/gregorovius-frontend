<template>
  <q-page padding>
    <div class="row">
    <div class="col-12 col-md-3">
      <q-card flat class="transparent">
        <div class="row justify-center">
          <select-auto-complete label="Empfänger" entity="recipient" :options="uniqueRecipients"/>
          <select-auto-complete label="Empfangsort" entity="placeReceived" :options="uniquePlacesReceived"/>
          <select-auto-complete label="Schreibort" entity="placeSent" :options="uniquePlacesSent"/>
          <select-auto-complete label="Jahr" entity="yearSpan"/>
        </div>
      </q-card>
    </div>
    <div class="q-pa-md col-12 col-md-9">
      <q-table
        :data="letters"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :filter-method="filterLetters"
        :pagination.sync="pagination"
        :loading="loading"
        :no-data-label="' '"
        binary-state-sort
        flat
      >
        <template v-slot:body-cell="props">
          <q-td :props="props" @click.native="$router.push({ name: 'Brief', params: { id: props.row.id } })" class="cursor-pointer">{{ props.value }}</q-td>
        </template>
      </q-table>
    </div>
    </div>
  </q-page>
</template>

<script>

import SelectAutoComplete from '../components/SelectAutoComplete.vue'
import { mapActions, mapState } from 'vuex'

export default {
  name: 'LettersIndex',
  components: {
    SelectAutoComplete
  },
  data () {
    return {
      model: '',
      filter: {
        recipient: '',
        placeSent: '',
        placeReceived: '',
        yearInterval: [],
      },
      loading: this.$store.state.isLoading,
      pagination: {
        rowsPerPage: 10,
      },
      columns: [
        {
          name: 'date',
          required: true,
          align: 'left',
          field: row => (row.properties.date ? new Date(row.properties.date) : null),
          format: val => (val ? val.toLocaleDateString('de-DE', {
            day: 'numeric', month: 'long', year: 'numeric'
          }) : 'o. D.'),
          sortable: true
        },
        {
          name: 'recipient',
          required: true,
          label: 'Empfänger',
          align: 'left',
          field: row => this.getFullNameArray(row.properties.recipient),
          format: val => val.join(', '),
          sortable: true
        },
        {
          name: 'placeSent',
          required: true,
          label: 'Schreibort',
          align: 'left',
          field: row => this.getFullName(row.properties.place.sent, 'o. O.'),
          sortable: true
        },
        {
          name: 'placeRecv',
          required: true,
          label: 'Empfangsort',
          align: 'left',
          field: row => this.getFullName(row.properties.place.received, 'o. O.'),
          sortable: true
        },
      ],
      data: [],
    }
  },
  async mounted () {
    await this.loadLetters()
    await this.loadFullNameIndex()
  },
  methods: {
    ...mapActions(['loadLettersAction', 'loadFullNameIndexAction']),

    async loadLetters () {
      await this.loadLettersAction()
    },

    async loadFullNameIndex () {
      await this.loadFullNameIndexAction()
    },

    getFullName (id, altName) {
      const fullName = this.fullNameIndex[id]
      return (fullName ? fullName : altName)
    },

    getFullNameArray (nameIdArray) {
      if (nameIdArray) {
        return nameIdArray.map((r) => {return this.getFullName(r, 'NN')}) 
      } else {
        return []
      }
    },

    getArrayOptions (entityName, propertyName) {
      // Get a set of possible values from an array property
      const optionIds = [].concat.apply([], this[entityName].map((e) => {
        const stack = propertyName.split('.');
        var output = e.properties
        while (stack.length > 1) {
          var output = output[stack.shift()]
        } 
        return output[stack.shift()]
      }))
      const uniqueIds = [...new Set(optionIds)].filter(id => id !== null)
      const idNameMap = uniqueIds.map((id) => {
        return {
          label: this.getFullName(id, 'NN'),
          value: id
        }
      })
      return idNameMap
    },

    getOptions (entityName, propertyName) {
      // Get a set of possible values from a string property
      const optionIds = this[entityName].map((e) => {
        const stack = propertyName.split('.');
        var output = e.properties
        while (stack.length > 1) {
          var output = output[stack.shift()]
        } 
        return output[stack.shift()]
      })
      const uniqueIds = [...new Set(optionIds)].filter(id => id !== null)
      const idNameMap = uniqueIds.map((id) => {
        return {
          label: this.getFullName(id, 'NN'),
          value: id
        }
      })
      return idNameMap
    },

    hasValue (item, property, value) {
      // Check if a property (Array or String) contains or is equal to a value
      const stack = property.split('.');
      var prop = item.properties
      while (stack.length > 1) {
        var prop = prop[stack.shift()]
      } 
      prop = prop[stack.shift()]

      if (prop instanceof Array) {
        return prop.includes(value)
      } else {
        return prop === value
      }
    },

    filterItems (objectArray, property, value) {
      const filtered = objectArray.filter((item) => {
        return this.hasValue(item, property, value)
      })
      return filtered
    },

    filterLetters (rows, terms, cols) {
      if (terms.recipient !== '') {
        rows = rows.filter((r) => this.hasValue(r, 'recipient', terms.recipient))
      }
      if (terms.placeSent !== '') {
        rows = rows.filter((r) => this.hasValue(r, 'place.sent', terms.placeSent))
      }
      if (terms.placeReceived !== '') {
        rows = rows.filter((r) => this.hasValue(r, 'place.received', terms.placeReceived))
      }
      return rows
    },

  },

  computed: {

    fullNameIndex () {
      return this.$store.getters.fullNameIndex
    },

    letters () {
      return this.$store.getters.letters
    },

    letters () {
      return this.$store.getters.letters
    },

    uniqueRecipients () {
      return this.getArrayOptions('letters', 'recipient')
    },

    uniquePlacesSent () {
      return this.getOptions('letters', 'place.sent')
    },

    uniquePlacesReceived () {
      return this.getOptions('letters', 'place.received')
    },
  },

  created () {
    this.$store.watch(
      (state, getters) => (getters.selectedRecipient),
      (newValue, oldValue) => {
        this.filter.recipient = newValue
      },
    ),
    this.$store.watch(
      (state, getters) => getters.selectedPlaceReceived,
      (newValue, oldValue) => {
        this.filter.placeReceived = newValue
      }
    ),
    this.$store.watch(
      (state, getters) => getters.selectedPlaceSent,
      (newValue, oldValue) => {
        this.filter.placeSent = newValue
      }
    )
  },

}
</script>

<style>
</style>
