{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Network.S3
    ( -- * Create pre-signed AWS S3 URL
      generateS3URL
      -- * Types
    , module Network.S3.Types
    ) where

import           Network.S3.Sign
import           Network.S3.Time
import           Network.S3.Types
import           Network.S3.URL

-- | Generates a cryptographically secure URL that expires within a
-- user defined period
generateS3URL :: S3Keys -> S3Request -> IO S3URL
generateS3URL S3Keys{..} S3Request{..} = do
  time <- getExpirationTimeStamp secondsToExpire
  let url = case s3method of
              S3GET -> getURL bucketName objectName time
              S3PUT -> putURL bucketName objectName time
      req = s3URL bucketName objectName publicKey time (sign secretKey url)
  return (S3URL req)

