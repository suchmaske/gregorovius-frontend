/* eslint-disable func-names */
import axios from 'axios';
import { API } from './config';

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
    item = undefined;
  }
  return item;
};

const getFullName = async function (name) {
  let fullName = 'NN';
  if (name.toponym) {
    fullName = name.toponym;
  } else if (name.surname && name.forename) {
    fullName = `${name.forename} ${name.surname}`;
  } else if (name.simpleName) {
    fullName = name.simpleName;
  } else if (name.roleName && name.simpleName) {
    fullName = `${name.simpleName}, ${name.roleName}`;
  } else if (name.roleName && name.forename) {
    fullName = `${name.forename}, ${name.roleName}`;
  } else if (name.orgName) {
    fullName = name.orgName;
  }
  return fullName;
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
    let data = parseList(response);
    return data;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const getFullNameIndex = async function () {
  try {
    const persons = await getEntities('persons');
    const institutions = await getEntities('institutions');
    const places = await getEntities('places');
    const entities = [...persons, ...institutions, ...places];
    let fullNameIndex = {}
    entities.map(async function (entity) {
        const targetEntity = entities.find(item => item.id === entity.id)
        fullNameIndex[entity.id] = await getFullName(targetEntity.properties.name)
    })
    return fullNameIndex
  } catch (error) {
    console.error(error);
    return [];
  }
}

export const dataService = {
  getEntities,
  getEntity,
  getLetters,
  getFullNameIndex,
};
