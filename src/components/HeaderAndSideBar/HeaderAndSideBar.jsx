// components/Header.jsx
import React,{useState} from 'react';
import logoWhite from '../../assets/images/logo_beyaz.png'
import logoMain from '../../assets/images/logo.png'
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import NotificationsIcon from '@mui/icons-material/Notifications';
import Avatar from '@mui/material/Avatar';
import Badge from '@mui/material/Badge';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import Drawer from '@mui/material/Drawer';
import TextField from '@mui/material/TextField';
import Autocomplete from '@mui/material/Autocomplete';
import SearchIcon from '@mui/icons-material/Search';
import SearchOffIcon from '@mui/icons-material/SearchOff';
import LanguageIcon from '@mui/icons-material/Language';
import BedtimeIcon from '@mui/icons-material/Bedtime';
import BedtimeOffIcon from '@mui/icons-material/BedtimeOff';
import LanguageIconSvg from '../LanguageIconSvg/LanguageIcon';
import { useMediaQuery } from '@mui/material';  
import { useNavigate } from 'react-router-dom'
import { useLocation } from 'react-router-dom'
import { Link as RouterLink } from 'react-router-dom'
import { useDispatch } from 'react-redux';
import {logOut} from '../../redux/slices/userSlice';
import { persistor } from '../../redux/store';

//  onClick={() => navigate(`${value.link}`)} Link işe yaramazsa

//Şuan notification özellikleri autocomplete'in heryere ulaşabilmesi yada drawer beğenilmezse yada başka stiller olursa değiştir

export default function Header() {

  //Buttonların Sayfa Yönlendirmesi Header için
  const navigate = useNavigate();
  const dispatch = useDispatch();

  // 1) Şu anda hangi menünün açık olduğunu ve anchor element'ini tutan tek bir state
  const [openMenu, setOpenMenu] = useState({ key: null, anchorEl: null })
  // 1.2) Search inputunda arama yapıldığını gösteren state
  const [searching, setSearching] = useState(false);
  //2) Linklerin mobil versiyonu için sol tarafta açılır kapanır menü yapmak için kullandığımız state
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);

  const navIconColor = "rgba(255, 255, 255, 0.55)";
  const mdScreen = useMediaQuery("(max-width: 992px) and (min-width: 601px)"); 
  const smScreen = useMediaQuery("(max-width: 601px)");

  //login kısmında header göstermemek için
  const {pathname} = useLocation();
  if (pathname === '/login') return null;

  //Header'a ait Sayfa Yönlendirmesi Header için
  const navItems = [
    { name: 'Ana Sayfa', link: '/' },
    { name: 'Kurslarım', link: '/courses' },
    { name: 'Notlarım', link: '/grades' },
    { name: 'Takvim', link: '/calendar' },
    { name: 'Sertifika ve Rozet', link: '/certificates-badges' },
    { name: 'Yetkinlikler', link: '/competencies' },
    { name: 'Öğrenme Patikası', link: '/learning-path' }
  ];

  //2) Menü açma fonksiyonu
  const toggleDrawer = (open) =>{
    setIsDrawerOpen(open);
  }

  // 1.2) Menü açma fonksiyonu, parametre olarak menü anahtarı (key) alıyor
  const handleOpenMenu = (key) => (event) => {
    setOpenMenu({ key, anchorEl: event.currentTarget });
  };

    // 1.3) Menü kapama fonksiyonu
  const handleCloseMenu = () => {
    setOpenMenu({ key: null, anchorEl: null });
  };

  // 1.4) çıkış işlemlerini halletmesi gereken fonk
  const handleLogOut = () =>{
    setOpenMenu({ key: null, anchorEl: null });
    dispatch(logOut());
    persistor.purge().then(() => {
      navigate('/login');
    });
  }

  const handleGoAccount = () => {
    setOpenMenu({ key: null, anchorEl: null });
    navigate('/account');
  }

  const calcShInputWidth = () =>{
    if (!searching) return "0px";
    return mdScreen? "18vw" : smScreen? "60vw" : "10vw";
  }

  return (
    <>

       {/*Mobil , tablet için sol tarafta açılacak olan menü*/}
      <Drawer variant='persistent' open={isDrawerOpen} anchor='left'
        sx={{
          '& .MuiDrawer-paper': {
            top: `94px`, // kendi header height
          }
        }} 
      >
        <Box sx={{
                    height: '100vh',
                    textAlign:"center", 
                    backgroundColor: "black",
                    width: {
                      xs: '80vw',   // 0–600px: ekranın %80’i
                      sm: '60vw',   // 600–900px: %60
                      md: '40vw',   // 900–1200px: %40
                      lg: '30vw',   // 1200px üzeri: %30
                    },
                  }}
        >
            {
              navItems && navItems.map((value,index)=>(
                <Button key={index} 
                onClick={() => {
                  toggleDrawer(false);
                  navigate(`${value.link}`);
                }} 
                size='small' 
                  sx={{
                        fontSize: "0.9rem",
                        minWidth: 0,
                        maxHeight: 100,
                        width: "100%",
                        height: "calc(100vh / 8)",
                        color: "#fff"
                  }}
                >
                  {value.name}
                </Button>
              )) 
            }
        </Box>
      </Drawer>

    </>

  );
}
