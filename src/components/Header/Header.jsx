// components/Header/Header.jsx
import React, { useState } from 'react';
import { useMediaQuery, IconButton, Avatar } from '@mui/material';
import { useNavigate, useLocation } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import NotificationsIcon from '@mui/icons-material/Notifications';
import Badge from '@mui/material/Badge';

import NavLinks from './NavLinks';
import SearchBar from './SearchBar';
import LanguageMenu from './LanguageMenu';
import UserMenu from './UserMenu';
import MobileDrawer from './MobileDrawer';
import LanguageIconSvg from '../LanguageIconSvg/LanguageIcon';
import { logOut } from '../../redux/slices/userSlice';
import { persistor } from '../../redux/store';

const Header = () => {
  const [openMenu, setOpenMenu] = useState({ key: null, anchorEl: null });
  const [searching, setSearching] = useState(false);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);

  const navIconColor = "rgba(255, 255, 255, 0.55)";
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const { pathname } = useLocation();

  if (pathname === '/login') return null;

  const handleOpenMenu = (key) => (e) => setOpenMenu({ key, anchorEl: e.currentTarget });
  const handleCloseMenu = () => setOpenMenu({ key: null, anchorEl: null });
  const handleLogOut = () => {
    handleCloseMenu();
    dispatch(logOut());
    persistor.purge().then(() => navigate('/login'));
  };
  const handleGoAccount = () => {
    handleCloseMenu();
    navigate('/account');
  };

  return (
    <header className="nav">
      <IconButton sx={{ color: "#fff" }} onClick={() => setIsDrawerOpen(true)}>
        <div className="hamburger"><span className="line" /><span className="line" /><span className="line" /></div>
      </IconButton>

      <div className="nav__link hide">
        <NavLinks color={navIconColor} />
      </div>

      <SearchBar searching={searching} setSearching={setSearching} navIconColor={navIconColor} />

      <div className="d-flex">
        <IconButton>
          <Badge badgeContent={1} color="error"><NotificationsIcon sx={{ color: navIconColor }} /></Badge>
        </IconButton>

        <div className="language dropdown-toggle">
          <a onClick={handleOpenMenu('language')}><LanguageIconSvg /></a>
        </div>

        <IconButton><Avatar onClick={handleOpenMenu('profile')} src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d" sx={{ width: 25, height: 25 }} /></IconButton>
      </div>

      <LanguageMenu anchorEl={openMenu.anchorEl} open={openMenu.key === 'language'} onClose={handleCloseMenu} />
      <UserMenu anchorEl={openMenu.anchorEl} open={openMenu.key === 'profile'} onClose={handleCloseMenu} onAccount={handleGoAccount} onLogOut={handleLogOut} />
      <MobileDrawer open={isDrawerOpen} toggleDrawer={setIsDrawerOpen} />
    </header>
  );
};

export default Header;
