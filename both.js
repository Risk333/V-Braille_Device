const net = require("net"); // Import network library (built-in with Node)

const server = net.createServer();

//using json parse and body parser
// const bodyParser = require("body-parser");
// const jsonParser = bodyParser.json();





var pico1_socket = null; //haptic devices  //id: 1
// var pico2_socket = null; //keyboard   //id: 2
var android_socket = null;


server.on("connection", (socket) => {

    

  socket.on("data", (data) => {
    //print type of data
    console.log("type of data: ",typeof data);
   
    //type of data is buffer so we need to convert it into string

    //parse data into json
    // console.log("data received from Picos : ","-->", data.toString()[0]);
    var data_obj = JSON.parse(data.toString());
    console.log("deviceid : ","-->", data_obj.deviceId);
    console.log("message : ","-->", data_obj.message?data_obj.message:"what");

    
    if(data_obj.deviceId == "1111"){
        console.log("haptic device");
        pico1_socket = socket;
    }else if(data_obj.deviceId == "2222"){
        console.log("keyboard");
        // pico2_socket = socket;jm
        sendDataToMobile(data_obj.message);
    }
    

    //sending data to mobile

   
  });
  socket.on("end", () => {
    console.log("client disconnected");
  });
});

// Catch errors as they arise
server.on("error", (err) => {
  console.error("server error:", err);
});




//function to send data to mobile

 function sendDataToMobile(data){
    if (android_socket != null) {
         console.log("sending data to mobile client");
        android_socket.emit("goToMobile", data);
    }else{
        console.log("socket is null");
    }
}















//socket.io server

const express = require("express");
const app = express();
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

app.use(cors());

const io_server = http.createServer(app);

const io = new Server(io_server, {
  cors: {
    // origin: "http://localhost:3000",
    // methods: ["GET", "POST"],
  },
});



io.on("connection", (socket) => {
    android_socket = socket;
  console.log(`mobile User Connected: ${socket.id}`);

  //for getting data from mobile
  socket.on("gotoserver", (data) => {
    console.log("data received from mobile: ", data);
   
    //sending data to pico1
    sendDataToPico1(data);
    
  });

  socket.on("disconnect", () => {
    console.log("mobile user disconnected");
  });

    socket.on("error", (err) => {
    console.log("error: ", err);
});


});


//function to send data to pico1

function sendDataToPico1(data){
    if (pico1_socket != null) {
        pico1_socket.write(data);
    }else{
        console.log("pico1socket is null");
    }
}



//socket.io server


io_server.listen(3010, () => {
  console.log(" socket IO Server listening on port 3010");
});

// net socket server
server.listen(3005, () => {
  console.log("net socket Server listening on port 3005");
});
