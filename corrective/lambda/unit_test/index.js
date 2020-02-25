process.env.AWS_PROFILE = 'privateS3';
const fs = require('fs')

const index = require("../function_code/index")
const input = JSON.parse(fs.readFileSync('../samples/compliance_status_change.json'))

index.handler(input,null,(e,d) => {
    if (e) console.error(e)
    console.log(d)
});
