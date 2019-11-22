<template>
  <q-page padding>
    <div class="row">
      <div class="col-12 col-md-3">
        <q-card flat class="transparent">
          <div class="q-gutter-sm col justify-center" style="max-width: 500px">
            <select-auto-complete
              label="Empfänger"
              entity="recipient"
              :options="uniqueRecipients"
            />
            <select-auto-complete
              label="Schreibort"
              entity="placeSent"
              :options="uniquePlacesSent"
            />
            <select-auto-complete
              label="Empfangsort"
              entity="placeReceived"
              :options="uniquePlacesReceived"
            />
            <select-years label="Jahre" entity="years" :options="uniqueYears" />
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
          binary-state-sort
          flat
        >
          <template v-slot:body-cell="props">
            <q-td
              :props="props"
              class="cursor-pointer"
              @click.native="$router.push({ name: 'Brief', params: { id: props.row.id } })"
            >
              {{ props.value }}
            </q-td>
          </template>
        </q-table>
      </div>
    </div>
  </q-page>
</template>

<script>
import { mapActions, mapState } from "vuex";
import SelectAutoComplete from "../components/SelectAutoComplete.vue";
import SelectYears from "../components/SelectYears.vue";

export default {
  name: "LettersIndex",
  components: {
    SelectAutoComplete,
    SelectYears
  },
  data() {
    return {
      model: "",
      filter: {
        recipient: "",
        placeSent: "",
        placeReceived: "",
        years: []
      },
      loading: this.$store.state.isLoading,
      pagination: {
        rowsPerPage: 20,
        sortBy: "date"
      },
      columns: [
        {
          name: "date",
          required: true,
          label: "Schreibdatum",
          align: "left",
          field: row => (row.properties.date ? new Date(row.properties.date) : new Date("2000")),
          format: val =>
            val.getFullYear() != "2000"
              ? val.toLocaleDateString("de-DE", {
                  day: "numeric",
                  month: "long",
                  year: "numeric"
                })
              : "o. D.",
          sortable: true
        },
        {
          name: "recipient",
          required: true,
          label: "Empfänger",
          align: "left",
          field: row => this.getFullNameArray(row.properties.recipient),
          format: val => val.join("; "),
          sortable: true
        },
        {
          name: "placeSent",
          required: true,
          label: "Schreibort",
          align: "left",
          field: row => this.getFullName(row.properties.place.sent, "o. O."),
          sortable: true
        },
        {
          name: "placeRecv",
          required: true,
          label: "Empfangsort",
          align: "left",
          field: row => this.getFullName(row.properties.place.received, "o. O."),
          sortable: true
        }
      ],
      data: []
    };
  },
  created() {
    for (const [paramKey, paramValue] of Object.entries(this.$route.query)) {
      this.setSelectedAction({entity: paramKey, value: paramValue});
    }
  },
  mounted() {
    this.$store.watch(
      (state, getters) => getters.loading,
      (newValue, oldValue) => {
        this.loading = newValue;
      }
    );
    this.loadAll();
  },
  methods: {
    ...mapActions(["loadLettersAction", "setLoadingStatus", "setSelectedAction"]),

    loadAll() {
      ['recipient', 'placeReceived', 'placeSent', 'years'].map(this.watchQueryParam)
      if (this.$store.getters.letters.length == 0) {
        this.loadLettersAction();
      }
      this.filter.recipient = this.$route.query.recipient ? this.$route.query.recipient : "";
      this.filter.placeSent = this.$route.query.placeSent ? this.$route.query.placeSent : "";
      this.filter.placeReceived = this.$route.query.placeReceived ? this.$route.query.placeReceived : "";
    },

    getFullName(id, altName) {
      const fullName = this.fullNameIndex[id];
      return fullName || altName;
    },

    getFullNameArray(nameIdArray) {
      if (nameIdArray) {
        return nameIdArray.map(r => this.getFullName(r, "NN"));
      }
      return [];
    },

    getArrayOptions(entityName, propertyName) {
      // Get a set of possible values from an array property
      const optionIds = [].concat.apply(
        [],
        this[entityName].map(e => {
          const stack = propertyName.split(".");
          var output = e.properties;
          while (stack.length > 1) {
            var output = output[stack.shift()];
          }
          return output[stack.shift()];
        })
      );
      const uniqueIds = [...new Set(optionIds)].filter(id => id !== null);
      const idNameMap = uniqueIds.map(id => ({
        label: this.getFullName(id, "NN"),
        value: id
      }));
      return idNameMap;
    },

    getOptions(entityName, propertyName) {
      // Get a set of possible values from a string property
      const optionIds = this[entityName].map(e => {
        const stack = propertyName.split(".");
        var output = e.properties;
        while (stack.length > 1) {
          var output = output[stack.shift()];
        }
        return output[stack.shift()];
      });
      const uniqueIds = [...new Set(optionIds)].filter(id => id !== null);
      const idNameMap = uniqueIds.map(id => ({
        label: this.getFullName(id, "NN"),
        value: id
      }));
      return idNameMap;
    },

    hasValue(item, property, value) {
      // Check if a property (Array or String) contains or is equal to a value
      const stack = property.split(".");
      var prop = item.properties;
      while (stack.length > 1) {
        var prop = prop[stack.shift()];
      }
      prop = prop[stack.shift()];

      if (prop instanceof Array) {
        return prop.includes(value);
      }
      return prop === value;
    },

    filterItems(objectArray, property, value) {
      const filtered = objectArray.filter(item => this.hasValue(item, property, value));
      return filtered;
    },

    filterLetters(rows, terms, cols) {
      if (terms.recipient !== "") {
        rows = rows.filter(r => this.hasValue(r, "recipient", terms.recipient));
      }
      if (terms.placeSent !== "") {
        rows = rows.filter(r => this.hasValue(r, "place.sent", terms.placeSent));
      }
      if (terms.placeReceived !== "") {
        rows = rows.filter(r => this.hasValue(r, "place.received", terms.placeReceived));
      }
      if (terms.years.length > 0) {
        rows = rows.filter(r =>
          !r.properties.date ? false : terms.years.includes(r.properties.date.slice(0, 4))
        );
      }
      return rows;
    },

    watchQueryParam(entityKey) {
      const selectedEntityKey = "selected" + entityKey[0].toUpperCase() + entityKey.slice(1)
      this.$store.watch(
        (state, getters) => getters[selectedEntityKey],
        (newValue, oldValue) => {
          this.filter[entityKey] = newValue.value;
          if (newValue.value == "") {
            var newQuery = {...this.$route.query}
            delete newQuery[entityKey]
            this.$router.push({query: newQuery});
          } else {
            this.$router.push({query: Object.assign({}, this.$route.query, {[entityKey]: newValue.value})});
          }
        }
      )
    },

    loadQueryToStore() {
      
    },

  },

  computed: {
    fullNameIndex() {
      return this.$store.getters.fullNameIndex;
    },

    letters() {
      return this.$store.getters.letters;
    },

    uniqueRecipients() {
      return this.getArrayOptions("letters", "recipient");
    },

    uniquePlacesSent() {
      return this.getOptions("letters", "place.sent");
    },

    uniquePlacesReceived() {
      return this.getOptions("letters", "place.received");
    },

    uniqueYears() {
      const years = this.letters.map(e => {
        try {
          return e.properties.date.slice(0, 4);
        } catch (TypeError) {}
      });
      return [...new Set(years)].filter(year => year !== undefined).sort();
    },

  },

};
</script>

<style></style>
