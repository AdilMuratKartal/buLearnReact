// components/Header/NavLinks.jsx
import React from 'react';
import { Button } from '@mui/material';
import { Link as RouterLink } from 'react-router-dom';
import { NAV_ITEMS,navIconColor } from './constants';
import logoWhite from '../../assets/images/logo_beyaz.png'


const NavLinks = ({ color = "#fff" }) => {
  return (
    <>
    <Button sx={{color: navIconColor}}><img className='logo-img' src={logoWhite} alt="BuLearn Logo"/></Button>
      {NAV_ITEMS.map((item, idx) => (
        <Button
          key={idx}
          component={RouterLink}
          to={item.link}
          sx={{ color, fontSize: "0.8rem", minWidth: 0 }}
          size="small"
        >
          {item.name}
        </Button>
      ))}
    </>
  );
};

export default NavLinks;
