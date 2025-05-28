import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import axios from 'axios'

const initialState = {
    
    loginData:{
        Username: "adilmuratkartal@gmail.com",//şuanlık bununla erişim sağlıyorum  
        Password: "ComputerScience5958!"
    },
    token:'',
    name: '',
    userCourseData: null,
    loading:false,
    error: null,
}

export const getUser = createAsyncThunk(
    "getUser", 
    async(_, thunkAPI)=>{
        const getState = thunkAPI.getState;
        const state = getState().user;
        try{
            const response = await axios.post("http://161.9.147.73/api/V3/Logon/Login",state.loginData,{
            headers: { "Content-Type": "application/json; charset=UTF-8" }
            });
            console.log("Response:" , response);
            console.log("Response.data:" , response.data);
            console.log("userSlice-state: ", getState().user)

            const token = response.data.message.token;
            const username2 = "Büşra Kirencioğlu"//burda verisi çok olan kişinin username'ini kullanarak veri çekmen gerekiyor öncelğin bu

            const queryData = {
                Token: token,
                DataStoreId: "51221426154257166557",
                Operation: "read",
                Encrypted: 1951,
                Data: `SELECT \"First Name\", \"Last Name\", \"Course\" , \"Grade\" FROM \"postgresSchema\".\"Course General\" WHERE \"Name\" = '${username2}'`
            };

            const userInfoResponse = await axios.post("http://161.9.147.73/api/V3/Applications/DataOps", queryData, {
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            });

            console.log("kullancı bilgileri",userInfoResponse.data.message)

            return {
                token,
                userCourseData: userInfoResponse.data.message
            };
  
        }catch(error){
            return thunkAPI.rejectWithValue(error.response?.data || error.message);
        }

        //return response.data; şu kısım ile yukarıdaki return arasındaki fark ne bunlar nasıl ayrışıyor ben nasıl kullanıcam
        //aslında component içinde kullandığım için ona göre return düşün be-ticaret sitesinde response.data [{id:1}{id:2}]
        // gibi dönüyor burdada arasından ayrıştırıp sadece userCourseData'yı almışısız işte aşağıki kısımı etkiliyormu etkiliyorsa kodu 
        //nasıl değiştiriceğine bakarsın
        //dediğim gibi return değişince buralarda değişiyor NOT: ****action.payload === response.data okey
    }
)

export const userSlice = createSlice({
    name:"user",
    initialState,
    reducers:{
        logOut: ()=>{
            return initialState;
        }
    },
    extraReducers:(builder) =>{
        builder.addCase(getUser.pending, (state) =>{
            state.loading = true;
            state.error = null;
        })
        builder.addCase(getUser.fulfilled, (state,action) =>{
            state.loading = false;
            state.token = action.payload.token;
            state.userCourseData = action.payload.userCourseData;
            console.log("Action: ", action);
            console.log("Action.payload.message.token ile alıyorsun tokeni eğer return response.data dersen: ", action.payload.token);
            
        })
        builder.addCase(getUser.rejected, (state, action) => {
            state.loading = false;
            state.error = action.payload;
            console.log("action.error === response.error gibi düşün: ", state.error)
        });
        
    }
})

export const {logOut} = userSlice.actions
export default userSlice.reducer