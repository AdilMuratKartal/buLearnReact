import React, { useState } from 'react'
import '../../components/Header/Header.css'
import { 
  Container,Card,CardMedia , CardContent, Typography, 
  CardActionArea,TextField, Stack,CardActions, IconButton,
  InputAdornment
} from '@mui/material'
import{
  BoxFlex,AccountButton,FullWidthBox, CustomCardMedia
}from './AccountStyle'
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import { useFormik } from 'formik';
import { loginFormSchemas } from '../../schemas/LoginFormSchemas';
import CheckCircleOutlineIcon from '@mui/icons-material/CheckCircleOutline';
import CancelIcon from '@mui/icons-material/Cancel';



function Account() {

  const [isRestricted, setIsRestricted] = useState(true);
  const [showPassword, setShowPassword] = useState(false);

  const handleClickShowPassword = () => {
    setShowPassword(!showPassword);
  };

  const handleUserInfoChange = () => {
    
    setIsRestricted(true);
    setShowPassword(false);
  }


  const userInfo = {
    userProfilPhoto: "https://cdn3.pixelcut.app/7/20/uncrop_hero_bdf08a8ca6.jpg",
    userName: "Burhan Günay",
    userMail: "burhan@gmail.com",
    userPassword: "117675123",
  }

  const submit = (values,actions) =>{
    setTimeout(()=>{
      console.log(values);
      console.log(actions);
      actions.resetForm();
      console.log(values);
    },2000)
  }

  //bu kısımda ilk olarak kullanıcı düzenle diyecek alanlar textfieldların disaebled kısmı false olucak
  //sonra başlangıç değerleri veri tabanından çektiğimiz user değerleri olucak
  //sonra kullanıcı güncelle dediğinde eğer bilgiler user'ın ilk aldığımız değerleri ile aynı ise değişmeyecek
  //eğerki kullanıcı şifresini değiştirdiyse değer aynı değilse bu sefer istek yollacak kullanıcı şifremi değiştir diye
  const {values,errors,handleChange,handleSubmit} = useFormik({
    initialValues: {
        username: userInfo.userMail,
        password: userInfo.userPassword
    },
    validationSchema: loginFormSchemas,
    onSubmit: submit
  })

  return (
    <div>
      <Container 
        sx={{display:'flex',justifyContent:"center",alignItems:"center",}}
      >
        <form id="updateForm" onSubmit={handleSubmit}>
          <Card sx={{width: '25vw',padding: 5, marginTop:"10vh"}}>

            <CardContent id='account-header'>
              <BoxFlex>
                <CustomCardMedia //bu customCardMedia sadece width props'una verdiğin kadar değer alıcak
                    component="img"
                    height="150"
                    width= {150}
                    image={userInfo.userProfilPhoto}
                    alt="Paella dish"
                    sx={{objectFit:"contain", borderRadius:"100px"}}
                />
              </BoxFlex>
              <Typography variant="h6" sx={{fontWeight: "bold"}}>
                <BoxFlex>{userInfo.userName}</BoxFlex>
              </Typography>
              <BoxFlex>
                <AccountButton onClick={() => {setIsRestricted(!isRestricted)}}>Profili Düzenle</AccountButton>
              </BoxFlex>
            </CardContent>

            <CardActions>
              <FullWidthBox id='account-input-container'>
                <Stack direction={'column'}>
                  <TextField
                    id= "username"
                    label= ""
                    variant='standard'
                    disabled= {isRestricted}
                    fullWidth
                    value = {values.username}
                    onChange={handleChange}
                    slotProps={{
                          input: {
                              endAdornment: <InputAdornment position="end">
                                              {
                                                isRestricted ? null : (
                                                  errors.username ? <CancelIcon /> : <CheckCircleOutlineIcon />
                                                )
                                              }
                                            </InputAdornment>,
                            }, 
                    }} 
                  >

                  </TextField>
                  <BoxFlex sx={{alignItems: "flex-end", justifyContent:"space-between"}}> 
                      {/*Burda oluşturduğum boxflexi override ettimki göz ikonu aşağıda kalsın */}
                    <TextField
                      id= "password"
                      label= ""
                      type={showPassword ? 'text' : 'password'}
                      variant='standard'
                      disabled= {isRestricted}
                      sx={{width: "90%"}}
                      value={values.password}
                      onChange={handleChange}
                      slotProps={{
                          input: {
                              endAdornment: <InputAdornment position="end">
                                              {
                                                isRestricted ? null : (
                                                  errors.password ? <CancelIcon /> : <CheckCircleOutlineIcon />
                                                )
                                              }
                                            </InputAdornment>,
                            }, 
                      }} 
                    >
                      
                    </TextField>
                    <IconButton onClick={handleClickShowPassword} sx={{ color: 'action.active'}} >
                        {showPassword ? <VisibilityIcon></VisibilityIcon> : <VisibilityOffIcon></VisibilityOffIcon> }
                    </IconButton> 
                  </BoxFlex>
                </Stack>
              </FullWidthBox>
            </CardActions>

            <CardActions>
              <FullWidthBox id='account-actions-container'>
                <Stack direction={'row'}
                  sx={{
                    justifyContent: "space-between",
                    alignItems: "center",
                    flexWrap: "wrap"
                  }}
                >
                  <AccountButton type='submit' onClick={handleUserInfoChange}>Güncelle</AccountButton>
                  <AccountButton onClick={handleUserInfoChange}>Vazgeç</AccountButton>
                </Stack>
              </FullWidthBox>
            </CardActions>
            
          </Card>
        </form>
      </Container>
    </div>
  )
}

export default Account