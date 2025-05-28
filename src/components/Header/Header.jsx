// components/Header.jsx
import React,{useState} from 'react';
import './Header.css'
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
    <header>
      <nav className="nav">
        {/* NAV CONTAINER */}
        <div className="container-fluid">
          <IconButton sx={{color: "#fff"}} onClick={() => toggleDrawer(true)}>
            <div className="hamburger">
              <span className="line" />
              <span className="line" />
              <span className="line" />
            </div>
          </IconButton>

          {/* LEFT-SIDE */}
          <div className="nav__link hide">
            <Button sx={{color: navIconColor}}><img className='logo-img' src={logoWhite} alt="BuLearn Logo"/></Button>

            {/* LEFT-LINKS */}
            <div className="left-links">
              {
                navItems && navItems.map((value,index)=>(
                  <Button key={index} component={RouterLink} to={value.link} size='small' 
                    sx={{
                      color: navIconColor, 
                      fontSize: "0.8rem",
                      minWidth: 0,
                      maxHeight: 100
                    }}
                  >
                    {value.name}
                  </Button>
                )) 
              }
            </div>
          </div>

          {/* SEARCHBAR */}
          <div className="search-container">
            <IconButton sx={{color: navIconColor}} onClick={()=>{setSearching(s => !s)}} >
              {
                searching? <SearchOffIcon/> : <SearchIcon sx={{color: navIconColor}} />
              }
            </IconButton>
            <Autocomplete
              freeSolo
              options={[...navItems.map((value)=>(
                  value.name
              ))
            ]}
              popupIcon={null}
              clearIcon={null}
              sx={{
                width: calcShInputWidth(),
                transition: 'width 0.3s ease',
                overflow: 'hidden',
                ml: 1,
                // TextField’in kök elemanına stili
                '& .MuiInputBase-root': {
                  color: navIconColor,               // girdinin yazı rengi
                  borderRadius: 1,                   // isteğe bağlı köşe yuvarlama
                  px: 1,                             // iç boşluk
                },
                // Placeholder rengini ayarla
                '& .MuiInputBase-input::placeholder': {
                  color: 'rgba(255,255,255,0.5)',
                  opacity: 1,                        // Firefox için
                },
              }}
              renderInput={(params) => (
                <TextField
                  {...params}
                  variant="standard"
                  placeholder="Ara…"
                  size="small"
                  // alt çizgi rengini de değiştir
                  InputProps={{
                    ...params.InputProps, 
                    disableUnderline: false,
                    sx: { 
                      '&:before': { borderBottomColor: 'rgba(255,255,255,0.5)' },
                      '&:hover:not(.Mui-disabled):before': { borderBottomColor: '#fff' },
                      '&:after': { borderBottomColor: navIconColor },
                    }
                  }}
                />
              )}
            />
          </div>


          {/* RIGHT ITEMS */}
          <div className="d-flex">
            {/* Dark-Light toggle */}
            <button id="theme-switch">
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px">
                <path d="M480-120q-150 0-255-105T120-480q0-150 105-255t255-105q14 0 27.5 1t26.5 3q-41 29-65.5 75.5T444-660q0 90 63 153t153 63q55 0 101-24.5t75-65.5q2 13 3 26.5t1 27.5q0 150-105 255T480-120Z" />
              </svg>
              <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px">
                <path d="M480-280q-83 0-141.5-58.5T280-480q0-83 58.5-141.5T480-680q83 0 141.5 58.5T680-480q0 83-58.5 141.5T480-280Zm0 440q150 0 255-105t105-255q0-150-105-255t-255-105q-150 0-255 105T120-280q0 150 105 255t255 105Z" />
              </svg>
            </button>

            {/* Notifications */}
            <IconButton
              size="small"
              aria-label="show new notifications"
              color="inherit"
              sx={{
                color: navIconColor,
                padding: 0
              }}
            >
              <Badge badgeContent={1} color="error" max={9} 
                sx={{
                      '& .MuiBadge-badge': {
                      fontSize: '12px',
                      height: '16px',
                      minWidth: '16px',
                      padding: '0 4px',
                      borderRadius: '8px',
                      right: '5px',
                      top: '5px'}
                }}
              >
                <NotificationsIcon sx={{color: navIconColor}}/>
              </Badge>
            </IconButton>

            {/* Language */}
            <div className="language dropdown-toggle">
              <a href="#" id="navbarDropdownMenuLanguage" aria-expanded="false" onClick={handleOpenMenu('language')}>
                {/*?xml version="1.0" encoding="UTF-8" standalone="no" ?*/}
                <LanguageIconSvg></LanguageIconSvg>
              </a>
            </div>


            {/* Avatar Dropdown */}
            <IconButton sx={{color: navIconColor}}>
              <Avatar alt="Remy Sharp" 
                src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d" 
                sx={{width: 25, height: 25}} onClick={handleOpenMenu('profile')} 
              />
            </IconButton>

            
          </div>
        </div>
      </nav>
    
    {/*Diller logosuna tıklanınca gelen dropdown*/}
      <Menu anchorEl={openMenu.anchorEl} open={openMenu.key === 'language'} onClose={handleCloseMenu} >
        <MenuItem onClick={handleCloseMenu}>English</MenuItem>
        <MenuItem onClick={handleCloseMenu}>Türkçe</MenuItem>
        <MenuItem onClick={handleCloseMenu}>中文</MenuItem>
        <MenuItem onClick={handleCloseMenu}>日本語</MenuItem>
        <MenuItem onClick={handleCloseMenu}>Deutsch</MenuItem>
        <MenuItem onClick={handleCloseMenu}>Français</MenuItem>
        <MenuItem onClick={handleCloseMenu}>Español</MenuItem>
        <MenuItem onClick={handleCloseMenu}>Русский</MenuItem>
      </Menu>

      {/*Profil logosuna tıklanınca gelen dropdown*/}
      <Menu anchorEl={openMenu.anchorEl} open={openMenu.key === 'profile'} onClose={handleCloseMenu}  >
        <MenuItem onClick={handleCloseMenu}>Profil</MenuItem>
        <MenuItem onClick={handleGoAccount}>Hesabım</MenuItem>
        <MenuItem onClick={handleLogOut}>Çıkış Yap</MenuItem>
      </Menu>

        {/*Mobil , tablet için sol tarafta açılacak olan menü*/}
      <Drawer open={isDrawerOpen} onClose={() => toggleDrawer(false)} anchor='left'>
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
                  }}>
            <Button 
              sx={{color: navIconColor, width: "100%",height: "calc(100vh / 8)"}}
              onClick={() => navigate(`/`)}
            >
              <img className='logo-img' src={logoWhite} alt="BuLearn Logo"/>
            </Button>
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


    </header>

    
  );
}
