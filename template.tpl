___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "MousePlayer",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "tagType",
    "displayName": "",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "config",
        "displayValue": "Configuration \u0026 Initialization"
      },
      {
        "value": "event",
        "displayValue": "Custom / E-commerce Event"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "channelId",
    "displayName": "Channel ID (Example: 955a45df5ee842cb)",
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "trackingMode",
    "displayName": "Tracking Mode",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "web_only",
        "displayValue": "Web Only"
      },
      {
        "value": "hybrid",
        "displayValue": "Hybrid (Web + CAPI)"
      },
      {
        "value": "pure_capi",
        "displayValue": "Pure CAPI"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "capiEndpoint",
    "displayName": "CAPI Endpoint (Optional, https://sst.mydomain.com/mp_capi)",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event Name",
    "simpleValueType": true
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "eventParams",
    "displayName": "",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Custom Parameter Key",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Custom Parameter Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "event",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const isnan = require('isNaN');
const number = require('Number');
const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');
const getType = require('getType');

const tagType = data.tagType;

if (tagType === 'config') {
  const configObj = {
    channel: data.channelId,
    mode: data.trackingMode || 'web_only',
    capi_endpoint: data.capiEndpoint || ''
  };
  
  setInWindow('mp_config', configObj, false);
  setInWindow('mp_channelid', data.channelId, false);
  
  const scriptUrl = 'https://www.mouseplayer.com/mp.js';
  injectScript(scriptUrl, data.gtmOnSuccess, data.gtmOnFailure, 'mouseplayer_script');

} else if (tagType === 'event') {
  let params = {};
  
  if (data.eventParams && data.eventParams.length > 0) {
    data.eventParams.forEach(row => {
      let val = row.value;
      if (val !== '' && !isnan(val)) {
        val = number(val);
      }
      params[row.key] = val;
    });
  }
  
  let mpFn = copyFromWindow('mp');
  
  if (getType(mpFn) === 'function') {
    callInWindow('mp', 'event', data.eventName, params);
  } else {
    let mpQueue = copyFromWindow('mp_q');
    if (getType(mpQueue) !== 'array') {
      mpQueue = [];
    }
    
    let newQueue = [];
    for (let i = 0; i < mpQueue.length; i++) {
      newQueue.push(mpQueue[i]);
    }
    newQueue.push(['event', data.eventName, params]);
    
    setInWindow('mp_q', newQueue, false);
  }
  data.gtmOnSuccess();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 27.7.2026, 19:30:48


