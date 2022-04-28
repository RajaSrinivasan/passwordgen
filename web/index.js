const express = require('express') ;
const { exec } = require("child_process");

const app = express() ;
const port = process.env.PORT || 3000;
app.get('/',(req,res) => {
    res.send('<p>Hello</p>');
});
app.get('/passwords',(req,res,next) => {
   //res.send('Will get you a list');
   exec("pwdbasic 12 @$ >./passwordstoday.txt", (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
    });
    const fn=`${process.env.PWD}/passwordstoday.txt` ;
    console.log('Sending ',fn);
    var options='';
    res.sendFile(fn,options, (err) => {
        if (err) {
          next(err)
        } else {
          console.log('Sent:', fn)
        } 
    } ) ;
});
app.listen(port,() => 
   console.log(`Running oon port ${port}`));
