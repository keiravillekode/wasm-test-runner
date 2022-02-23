/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */

export default {
  preset: 'ts-jest',
  testEnvironment: 'node',
  maxWorkers: 1,
  extensionsToTreatAsEsm: ['.ts'],
  globals: {
    'ts-jest': {
      useESM: true,
    },
  },
}
