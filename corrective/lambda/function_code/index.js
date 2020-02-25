const AWS = require('aws-sdk')

exports.handler = (event, context, callback) => {
    let s3 = new AWS.S3()

    let params = {
        Bucket: event.detail.resourceId, /* required */
        PublicAccessBlockConfiguration: { /* required */
          BlockPublicAcls: true,
          BlockPublicPolicy: true,
          IgnorePublicAcls: true,
          RestrictPublicBuckets: true
        }
      };
      s3.putPublicAccessBlock(params,callback)
}