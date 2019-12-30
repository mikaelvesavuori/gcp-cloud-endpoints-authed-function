# Using Google Cloud Functions with Cloud Endpoints for authorization (API key)

If you, like me, have used a lot of AWS Lambda and AWS API Gateway, you're probably a bit pampered with how much you get from the (pay-per-use, managed) boxes. Google, as much as I prefer their cloud offering, doesn't have anything quite that powerful to offer, nor anything super-clear on how to do API management. And, no, Apigee doesn't make the cut since it's kind of it's own thing and seems really expensive.

While API security best practices today outline a few other (better) ways to authenticate to an API, at least knowing how to do a basic gateway in Google Cloud Platform leveraging a simple API key is something I bet a lot of folks have wanted to support private functionality. Right now, the "easiest" and most flexible way to do that is to use [Cloud Endpoints](https://cloud.google.com/endpoints/), an open-source offering by Google that seems to be quite flexible.

It took me until now (!) to use it though:

1. Not super-clear always how to use Cloud Endpoints
2. Same thing for use cases: was my use case valid?
3. I was also harboring a childish fantasy that maybe, just maybe, Google would actually have a slick product to do this that I didn't know about

Then I came upon [Guillaume Blaquiere](https://github.com/guillaumeblaquiere) brilliant [write-up on Medium](https://medium.com/google-cloud/secure-cloud-run-cloud-functions-and-app-engine-with-api-key-73c57bededd1) that totally clicked with me. He shows how to do just want I want with Cloud Run, Cloud Functions and App Engine. I'm mostly a Cloud Functions person so this repo serves that perspective. It should be easy enough to adapt what you need. Guillaume has a very good repository as well, check it out!

I am sharing my take on it as it's leaner and more direct to my own sensibilities and it should be possibly to run all the scripted steps in two batches (you need to step to export a variable somewhere in the middle).

Kudos for best prior art goes to Guillaume and I hope someone out there gets their first taste of Cloud Endpoints, since at least I think that Google should spend time doing something kick-ass on the API management end to fight Amazon a bit harder ;)
