

Run the function from the console page in the browser. Clear the page, add the function and press enter.

Check the encryption type:
First time I ran it, it was a cypher text with ROT13 encryption.

2nd time was base64:

Use curl to create http POST request to call the api:

(Someone else’s) Alternate method for a POST request:

With Burpsuite loaded with proxy matched to firefox's proxy and certificate.

Send to repeater:
Change POST request from /invite to /api/invite/generate

Response 200 OK with code at the bottom


