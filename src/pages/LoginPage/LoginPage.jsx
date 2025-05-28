import React, { useEffect } from 'react'
import { useState } from 'react'
import './LoginPage.css'
import logo from '../../assets/images/logo.png'
import {useDispatch, useSelector} from 'react-redux'
import { getUser } from '../../redux/slices/userSlice';
import { useFormik } from 'formik';
import { loginFormSchemas } from '../../schemas/LoginFormSchemas';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import IconButton from '@mui/material/IconButton';
import { Button } from '@mui/material';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import { useNavigate } from 'react-router-dom'
//BURDAKİ CSS BAŞKA DOSYALARI ETKİLEMESİN AYNI ŞEKİLDE DİĞERLERİDE DİĞERİNİ ETKİLEMEMESİNİN YOLUNU BUL BEN ŞİMDİLİK LOGİNİ BODY İLE DEĞİL BİR DİV İLE ORTALAYACAĞIM ŞİMDİLİK İŞE YARADI EĞER AYNI CSS COMBİNATORE AİT ELEMENTLER COMPONENTSLER VARSA SIÇTIN 


function LoginPage() {

  const dispatch = useDispatch();
  const navigate = useNavigate();

  useEffect(() => {
    dispatch(getUser());
  }, [])

  const [showPassword, setShowPassword] = useState(false);

  const handleClickShowPassword = () => {
    setShowPassword(!showPassword);
  };

  const submit = (values,actions) =>{
    setTimeout(()=>{
      console.log(values);
      actions.resetForm();
      navigate('/');
    },2000)
  }

  const {values,errors,handleChange,handleSubmit} = useFormik({
    initialValues: {
        username: '',
        password: ''
    },
    validationSchema: loginFormSchemas,
    onSubmit: submit
  })

  return (
  <div className='loginForm-container'>
    <div className="overlay">
      <form id="loginForm" onSubmit={handleSubmit}>
        <div className="con">
          <header className="head-form">
            <img src={logo} alt="BuLearn Öğrenim Platformu" className='logo'/>
          </header>

          <div className="field-set">
            <div style={{position: "relative"}}>
              <TextField
                  fullWidth
                  id="username"
                  label= 'Kullanıcı Adınızı Giriniz'
                  value = {values.username}
                  onChange={handleChange}
                  slotProps={{
                      input: {
                          endAdornment: <InputAdornment position="end"><AccountCircleIcon sx={{padding: "8px 8px 8px 8px"}} /></InputAdornment>,
                        }, }} 
                  variant='outlined'>    
              </TextField>
              {errors.username && <p className='input-error'> {errors.username} </p>}
            </div>

            <div style={{position: "relative"}}>
              <TextField
                  fullWidth
                  type={showPassword ? 'text' : 'password'}
                  id="password"
                  label= 'Şifrenizi Giriniz'
                  value = {values.password}
                  onChange={handleChange}
                  slotProps={{
                      input: {
                          endAdornment: <InputAdornment position="end">
                                          <IconButton onClick={handleClickShowPassword}>
                                              {showPassword ? <VisibilityIcon></VisibilityIcon> : <VisibilityOffIcon></VisibilityOffIcon> }
                                          </IconButton> 
                                        </InputAdornment>,
                        }, }} 
                  variant='outlined'>    
              </TextField>
              {errors.password && <p className='input-error'> {errors.password} </p>}
            </div>

            <Button type='submit' variant='contained'>Giriş Yapınız</Button> {/*Şu anlık bir kullanıcı authentication yapmayacağız kullanıcı sorgulamayacazğız*/}
          </div>

          <div className="other">
            <Button size='small' 
              sx={{
                  fontFamily: '"Arial", sans-serif',  // çift tırnak + yedek font önerilir
                  textTransform: 'none',              // "BUTON" yerine "Buton" gibi yazı için
                  fontSize: '14px'
              }}>
              Şifremi Unuttum
            </Button>
            <Button size='small' 
              endIcon={<PersonAddIcon />} 
              sx={{
                  fontFamily: '"Arial", sans-serif',  // çift tırnak + yedek font önerilir
                  textTransform: 'none',              // "BUTON" yerine "Buton" gibi yazı için
                  fontSize: '14px'
              }}>
              Kaydol
            </Button>                 

          </div>

        </div>
      </form>
    </div>
  </div>
  )
}

export default LoginPage