import mongoose from "mongoose";
const Schema = mongoose.Schema;

const UserSchema = new Schema({

    empId:{
        type:String,
        required: true,
        unique:true,
    },

    password:{
        type:String,
        required: true,
            
    },

    role:{
        type:String,
        required:true
    }
});

const User = mongoose.model("User", UserSchema);

export default User;

