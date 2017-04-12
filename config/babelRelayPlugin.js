var getbabelRelayPlugin = require('babel-relay-plugin');
var schema = require('../schema/generated_schema_relay.json');

module.exports = getbabelRelayPlugin(schema.data);
