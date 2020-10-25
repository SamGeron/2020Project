## My solution to hack the login page to *HackTheBox* to generate an invite key.


![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture1.png)

View the source code:

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture2.png)

Find the suspiscious Javascript.

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture3.png)

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture4.png)

De-obfuscate the Javascript.

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture5.png)

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture6.png)

Run the function from the console page in the browser:

Open console.

Clear the page, add the function, without the rest of the Javascript and press enter.

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture7.png)

Check the encryption type (hint is always provided below the key code):

First time I ran it, it was a cypher text with ROT13 encryption.

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture8.png)

2nd time was base64:

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture9.png)

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture10.png)

Use curl to create http POST request to call the api:

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture11.png)

Decrypt Base64 ecrypted invite key:

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture12.png)

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture13.png)

Alternate method for a POST request using Burp Suite (not my own solution, sourced from jamesdotcom.com):

With Burpsuite loaded and configured to intercept from the browser -
Activate intercept, type in anything into HackTheBox invite code frame and capture a genuine POST request in Burp Suite.

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture14.png)

Send to repeater:

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture15.png)

Change POST request from /invite to /api/invite/generate

Response 200 OK 

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture12.png)

with code at the bottom

![alt text](https://github.com/SamGeron/2020Projects/blob/main/HacktheBox/images/Picture12.png)

then decrypt as above with any Base64 decoder.

