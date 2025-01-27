const express = require('express');
const cors = require('cors'); 
const app = express();
// const mongoose = require('mongoose');
// const uri = 'mongodb+srv://abhirajtr:abhirajtr@cluster0.wagtvjr.mongodb.net/NoteApp?retryWrites=true&w=majority&appName=Cluster0'
// mongoose.connect(uri, (err) => {
//     if (!err) {
//         console.log('Database Connected');
//     } else {
//         console.log('Database Connection failed');
//     }
// })

app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.use(cors())

const notes = [];

app.get("/", (req, res) => {
    try {
        res.send("hello")
    } catch (error) {
        console.log(error.message);
    }
})


app.post("/addNode", (req, res) => {
    try {
        // console.log(req.body);
        const data = {
            "id": req.body.id,
            "title": req.body.title,
            "content": req.body.content,
            "date": req.body.date
        }
        notes.push(data);
        console.log(data);
        res.status(200).send(notes);
    } catch (error) {
        console.log(error.message);
    }
})



app.get("/getAllNotes", (req, res) => {
    try {
        res.send(notes);
    } catch (error) {
        console.log(error.message);
    }
})


app.post("/updateNote/:id", (req, res) => {
    try {
        const id = parseInt(req.params.id);
        console.log(id);
        console.log(req.body);
        const title = req.body.title
        const content = req.body.content

        for (let i = 0; i < notes.length; i++) {
            if (notes[i].id === id) {
                notes[i].title = title
                notes[i].content = content
                console.log("Note updated successfully");
                // console.log(notes);
            } else {
                console.log("Note not found");
            }
        }
        res.status(200).send(notes);
    } catch (error) {
        console.log(error.message);
    }
})



app.post("/deleteNote/:id", (req, res) => {
    try {
        const id = parseInt(req.params.id);
        // console.log(id);
        // console.log(notes);
        for (let i = 0; i < notes.length; i++) {
            if (notes[i].id === id) {
                notes.splice(i, 1);
                console.log("Note deletion successfully");
                break;
            } else {
                console.log("Note not found");
            }
        }
        res.status(200).send(notes);
    } catch (error) {
        console.log(error.message);
    }
})


app.listen(3000, () => {
    console.log('Server is running on port 3000');
});