import React, { useState,useEffect } from 'react';
import './Header.css';
import logoWhite from '../../assets/images/logo_beyaz.png';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import NotificationsIcon from '@mui/icons-material/Notifications';
import Avatar from '@mui/material/Avatar';
import Badge from '@mui/material/Badge';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import Drawer from '@mui/material/Drawer';
import {Toolbar} from '@mui/material';
import TextField from '@mui/material/TextField';
import Autocomplete from '@mui/material/Autocomplete';
import SearchIcon from '@mui/icons-material/Search';
import SearchOffIcon from '@mui/icons-material/SearchOff';
import LanguageIcon from '@mui/icons-material/Language';
import { useMediaQuery } from '@mui/material';
import { useSelector, useDispatch } from 'react-redux';
import { toggleSidebar} from '../../redux/slices/uiSlice'; 

export default function Header() {
  //DropdownListler language ve profilde var
  const [openMenu, setOpenMenu] = useState({ key: null, anchorEl: null });
  const [searching, setSearching] = useState(false);
  const dispatch = useDispatch();


  const navIconColor = 'rgba(255, 255, 255, 0.55)';
  const mdScreen = useMediaQuery('(max-width: 992px) and (min-width: 601px)');
  const smScreen = useMediaQuery('(max-width: 601px)');

  const navItems = [
    { name: 'Ana Sayfa', link: '/' },
    { name: 'Kurslarım', link: '/courses' },
    { name: 'Notlarım', link: '/grades' },
    { name: 'Takvim', link: '/calendar' },
    { name: 'Sertifika ve Rozet', link: '/certificates-badges' },
    { name: 'Yetkinlikler', link: '/competencies' },
    { name: 'Öğrenme Patikası', link: '/learning-path' },
  ];

  const handleOpenMenu = (key) => (event) => setOpenMenu({ key, anchorEl: event.currentTarget });
  const handleCloseMenu = () => setOpenMenu({ key: null, anchorEl: null });

  const calcShInputWidth = () => {
    if (!searching) return '0px';
    return mdScreen ? '18vw' : smScreen ? '60vw' : '10vw';
  };

  return (
    <>
      <header id="headerBar">
        <nav className="nav">
          <div className="container-fluid">
            <IconButton sx={{ color: '#fff' }} onClick={() => dispatch(toggleSidebar())}>
              <div className="hamburger">
                <span className="line" />
                <span className="line" />
                <span className="line" />
              </div>
            </IconButton>

            <div className="nav__link hide">
              <Button sx={{ color: navIconColor }} href="/">
                <img className="logo-img" src={logoWhite} alt="BuLearn Logo" />
              </Button>
            </div>

            <div className="search-container">
              <IconButton sx={{ color: navIconColor }} onClick={() => setSearching((s) => !s)}>
                {searching ? <SearchOffIcon /> : <SearchIcon />}
              </IconButton>
              <Autocomplete
                freeSolo
                options={navItems.map((item) => item.name)}
                popupIcon={null}
                clearIcon={null}
                sx={{
                  width: calcShInputWidth(),
                  transition: 'width 0.3s ease',
                  overflow: 'hidden',
                  ml: 1,
                  '& .MuiInputBase-root': { color: navIconColor, borderRadius: 1, px: 1 },
                  '& .MuiInputBase-input::placeholder': { color: 'rgba(255,255,255,0.5)', opacity: 1 },
                }}
                renderInput={(params) => (
                  <TextField
                    {...params}
                    variant="standard"
                    placeholder="Ara…"
                    size="small"
                    InputProps={{
                      ...params.InputProps,
                      disableUnderline: false,
                      sx: {
                        '&:before': { borderBottomColor: 'rgba(255,255,255,0.5)' },
                        '&:hover:not(.Mui-disabled):before': { borderBottomColor: '#fff' },
                        '&:after': { borderBottomColor: navIconColor },
                      },
                    }}
                  />
                )}
              />
            </div>

            <div className="d-flex">
              <button id="theme-switch">{/* theme icons */}</button>
              <IconButton size="small" color="inherit" sx={{ color: navIconColor, padding: 0 }}>
                <Badge badgeContent={1} color="error" max={9} sx={{ '& .MuiBadge-badge': { fontSize: '12px', height: '16px', minWidth: '16px', padding: '0 4px', borderRadius: '8px', right: '5px', top: '5px' } }}>
                  <NotificationsIcon />
                </Badge>
              </IconButton>
              <div className="language dropdown-toggle">
                <a href="#" onClick={handleOpenMenu('language')}><LanguageIcon /></a>
              </div>
              <IconButton sx={{ color: navIconColor }} onClick={handleOpenMenu('profile')}>
                <Avatar alt="User Avatar" src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d" sx={{ width: 25, height: 25 }} />
              </IconButton>
            </div>
          </div>
        </nav>


        <Menu anchorEl={openMenu.anchorEl} open={openMenu.key === 'language'} onClose={handleCloseMenu}>
          <MenuItem onClick={handleCloseMenu}>English</MenuItem>
          <MenuItem onClick={handleCloseMenu}>Türkçe</MenuItem>
          <MenuItem onClick={handleCloseMenu}>中文</MenuItem>
          <MenuItem onClick={handleCloseMenu}>日本語</MenuItem>
          <MenuItem onClick={handleCloseMenu}>Deutsch</MenuItem>
          <MenuItem onClick={handleCloseMenu}>Français</MenuItem>
          <MenuItem onClick={handleCloseMenu}>Español</MenuItem>
          <MenuItem onClick={handleCloseMenu}>Русский</MenuItem>
        </Menu>

        <Menu anchorEl={openMenu.anchorEl} open={openMenu.key === 'profile'} onClose={handleCloseMenu}>
          <MenuItem onClick={handleCloseMenu}>Profil</MenuItem>
          <MenuItem onClick={handleCloseMenu}><a href="/account">Hesabım</a></MenuItem>
          <MenuItem onClick={handleCloseMenu}>Çıkış Yap</MenuItem>
        </Menu>


      </header>


    

      </>
  );
}
