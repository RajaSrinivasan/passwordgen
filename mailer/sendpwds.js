var nodemailer = require('nodemailer');
const { exec } = require("child_process");

exec("pwdbasic 12 >./passwordstoday.txt", (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
});

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 's@srin.me',
    pass: '8689Honeymead'
  }
});

var mailOptions = {
  from: 's@srin.me',
  to: 's@srin.me, g@srin.me',
  subject: 'Sending Email using Node.js',
  attachments: [{'filename': 'passwordstoday.txt', 'path': './passwordstoday.txt'}]
};

transporter.sendMail(mailOptions, function(error, info){
    if (error) {
        console.log(error);
    } else  {
        console.log('Email sent: ' + info.response);
    }
});