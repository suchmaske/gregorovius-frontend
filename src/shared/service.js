/* eslint-disable func-names */
import axios from 'axios';
import { API, XSLTToken } from './config';

const parseList = (response) => {
  if (response.status !== 200) throw Error(response.message);
  if (!response.data) return [];
  let list = response.data;
  if (typeof list !== 'object') {
    list = [];
  }
  return list;
};

const parseItem = (response, code) => {
  if (response.status !== code) throw Error(response.message);
  let item = response.data;
  if (typeof item !== 'object') {
    item = '';
  }
  return item;
};

const getFullName = async function (name) {
  if (name.toponym) {
    return name.toponym;
  } if (name.surname && name.forename) {
    return `${name.surname}, ${name.forename}`;
  } if (name.forename) {
    return name.forename;
  } if (name.surname) {
    return name.surname;
  } if (name.roleName && name.simpleName) {
    return `${name.simpleName}, ${name.roleName}`;
  } if (name.simpleName) {
    return name.simpleName;
  } if (name.roleName && name.forename) {
    return `${name.forename}, ${name.roleName}`;
  } if (name.orgName) {
    return name.orgName;
  }
  return 'NN';

};

const getEntities = async function (entityName) {
  try {
    const response = await axios.get(
      `${API}/${entityName}`, {
        headers: {
          Accept: 'application/json',
        },
      },
    );
    const data = parseList(response, 200);
    const entities = data.map((e) => {
      if (e.properties.name) {
        e.properties.name.fullName = getFullName(e.properties.name);
        return e;
      }
    });
    return entities;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const getEntity = async function (entityName, id, format) {
  try {
    const response = await axios.get(
      `${API}/${entityName}/${id}`, {
        headers: {
          Accept: `application/${format}`,
        },
      },
    );
    const entity = parseItem(response, 200);
    return entity;
  } catch (error) {
    console.error(error);
    return null;
  }
};

const getLetters = async function () {
  try {
    const response = await axios.get(
      `${API}/letters`, {
        headers: {
          Accept: 'application/json',
        },
      },
    );
    const data = parseList(response);
    return data;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const getFullNameIndex = async function () {
  try {
    const persons = await getEntities('persons');
    const places = await getEntities('places');
    const entities = [...persons, ...places];
    const fullNameIndex = {};
    entities.map(async (entity) => {
      const targetEntity = entities.find(item => item.id === entity.id);
      fullNameIndex[entity.id] = await getFullName(targetEntity.properties.name);
    });
    return fullNameIndex;
  } catch (error) {
    console.error(error);
    return [];
  }
};


const XSLTransform = async function (path, xsltName) {
  try {
    const stylesheetModule = await import(`@/assets/xslt/${xsltName}.xslt`);
    const stylesheet = stylesheetModule.default;
    const response = await axios.post(
      `${API}${path}`,
      stylesheet,
      {
        params: {
          xslt: true,
        },
      },
    );
    if (response.data === '') {
      return '';
    }
    return `<div xmlns:v-bind="https://vuejs.org/v2/api/#v-bind" 
          xmlns:v-on="https://vuejs.org/v2/api/#v-on">${response.data}</div>`;
  } catch (error) {
    console.error(error);
    return '';
  }
};

export const dataService = {
  getEntities,
  getEntity,
  getLetters,
  getFullName,
  getFullNameIndex,
  XSLTransform,
};
