import * as React from 'react';
import { useState,useEffect,useRef } from 'react';
import Box from '@mui/material/Box';
import CssBaseline from '@mui/material/CssBaseline';
import MuiDrawer from '@mui/material/Drawer';
import List from '@mui/material/List';
import Divider from '@mui/material/Divider';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import InboxIcon from '@mui/icons-material/MoveToInbox';
import MailIcon from '@mui/icons-material/Mail';
import MenuIcon from '@mui/icons-material/Menu';
import MenuOpenIcon from '@mui/icons-material/MenuOpen';
import { Button,useMediaQuery } from '@mui/material'; 
import { styled, alpha, useTheme } from '@mui/material/styles';
import { useSelector, useDispatch } from 'react-redux';
import { toggleSidebar, setSelectedIndex,setHeaderHeight,setIsMobile } from '../../redux/slices/uiSlice';
import { Route } from 'react-router-dom';
import HomeIcon from '@mui/icons-material/Home';
import GradeIcon from '@mui/icons-material/Grade';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import WorkspacePremiumIcon from '@mui/icons-material/WorkspacePremium'; 
import PsychologyIcon from '@mui/icons-material/Psychology'; 
import RouteIcon from '@mui/icons-material/Route'; 

const expandedDrawerWidth = 250;
const stdDrawerWidth = 83 ;

const DrawerHeader = styled("div")(({ theme }) => ({
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
}));

// Styled bileşeni doğru şekilde tanımlıyoruz
const PermanentDrawer = styled(MuiDrawer, { shouldForwardProp: (prop) => prop !== 'open' })(
  ({ theme, open }) => ({
    width: open ? expandedDrawerWidth : stdDrawerWidth,
    flexShrink: 0,
    
    boxSizing: 'border-box',
    '& .MuiDrawer-paper': {
      width: open ? expandedDrawerWidth : stdDrawerWidth,
      transition: theme.transitions.create('width', {
        easing: theme.transitions.easing.sharp,
        duration: theme.transitions.duration[open ? 'enteringScreen' : 'leavingScreen'],
      }),
      overflowX: 'hidden',
    },
  }),
);

// Drawer içeriğini ayrı bir bileşen olarak tanımlıyoruz (performans için)
const DrawerContent = React.memo(function DrawerContent({isOpen,handleListItemClick,selectedIndex2 }) {
  const theme = useTheme();

  return (
    <Box>
      <List
        sx={{
          width: isOpen ? expandedDrawerWidth : stdDrawerWidth,
          px: 1,
        }}
      >
        {[{text:'Home',icon:<HomeIcon/>}, {text:'Grades',icon:<GradeIcon/>}, 
          {text:'Calendar',icon:<CalendarMonthIcon/>},{text:'Certificates and Badges',icon:<WorkspacePremiumIcon/>},  
          {text:'Competencies',icon:<PsychologyIcon/>}, {text:'Learning Path',icon:<RouteIcon/>}, 
         ].
          map((navItems, index) => (
            <ListItem
              key={navItems.text}
              sx={{
                display: 'flex',
                justifyContent: 'center',
                p: 0,
              }}
            >
              <ListItemButton
                onClick={() => handleListItemClick(index)}
                selected={selectedIndex2 === index}
                sx={{
                  width: '100%',
                  minHeight: 58,
                  flexDirection: isOpen ? 'row' : 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  px: 1,
                  py: isOpen ? 0.5 : 1,
                  borderRadius: 2,
                  flexWrap: 'wrap',
                  '&.Mui-selected': {
                    backgroundColor: alpha(theme.palette.primary.main, 0.1),
                    color: 'primary.light',
                  },
                }}
              >
                <ListItemIcon
                  sx={{
                    minWidth: 0,
                    mb: 0,
                    mr: isOpen ? 2 : 0,
                    justifyContent: 'center',
                    '& svg': {
                      fill: (theme) => 
                        selectedIndex2 === index 
                          ? theme.palette.primary.light 
                          : "#ecf0f1",
                      fontSize: '1.5rem',
                      transition: 'fill 0.3s ease'
                    }
                }}
              >
                {navItems.icon}
              </ListItemIcon>

              <ListItemText
                primary={navItems.text}
                disableTypography={false}
                slotProps={{
                  primary: {
                    sx: {
                      minWidth: 0,
                      flexGrow: isOpen ? 1 : 0,
                      wordWrap:"break-word",
                      wordBreak:"break-word",
                      height:"min-content",
                      textAlign: isOpen ? 'start' : 'center',
                      fontSize: isOpen ? '1rem' : '0.7rem',
                      
                    },
                  },
                }}
                sx={{ m: 0 }}
              />
              </ListItemButton>
            </ListItem>
        ))}
      </List>

    </Box>
  );
});


export default function SideBar() {

  //burda seçilenıtem vs bunları reduxtan alıcaz state yöentimi redux'a bıraktım yukarıdan prop almasın diye
  const dispatch = useDispatch();
  const isOpen = useSelector(state => state.ui.isOpen);
  const selectedIndex2 = useSelector(state => state.ui.selectedIndex)
  const headerHeight = useSelector(state => state.ui.headerHeight);
  const isMobile = useSelector(state => state.ui.isMobile);

  //her dispacth çalıştığında header'ın boyunu alıcak
  useEffect(() => {
    
    const measure = () => {
      const headerEl = document.getElementById('headerBar');
      if(headerEl){
        dispatch(setHeaderHeight(headerEl.clientHeight));
        console.log(headerEl.clientHeight)
      }
    }
    measure();

  },[dispatch,isOpen])
  
  const handleListItemClick = (index) => {
    dispatch(setSelectedIndex(index));
    handleDrawerClose();
  };

  const handleDrawerToggle = () => {
    dispatch(toggleSidebar());
  };

  const handleDrawerClose = () => {
    if (isMobile) {
      dispatch(toggleSidebar());
    }
  };

  return (
    <Box sx={{ display: 'flex', backgroundColor:"rgba(51, 45, 45, 1);" }}>
      <CssBaseline />
      
      {isMobile ? (
        <MuiDrawer
          variant="temporary"
          open={isOpen}
          onClose={handleDrawerClose}
          ModalProps={{ keepMounted: true }}
          PaperProps={{
            sx:{
              backgroundColor:"rgba(51, 45, 45, 1)",
              color: "#ecf0f1",
            }
          }}
        >
          <DrawerHeader sx={{height:headerHeight}}>
            <Button onClick={handleDrawerToggle}>
              <MenuOpenIcon/>
            </Button>
          </DrawerHeader>
          <Divider sx={{backgroundColor:"#ecf0f1"}}/>
          <DrawerContent 
            isOpen={true} 
            handleDrawerClose={handleDrawerClose} 
            selectedIndex2={selectedIndex2} 
            handleListItemClick={handleListItemClick} 
          />
        </MuiDrawer>//isOpen true olamsının nedeni mobilde iken drawercontentin kapalı stillerine gerek olmaması
      ) : (
        <PermanentDrawer
          variant="permanent"
          open={isOpen}
          PaperProps={{
            sx:{
              backgroundColor:"rgba(51, 45, 45, 1)",
              color: "#ecf0f1",
            }
          }}         
        >
          <DrawerHeader sx={{height:headerHeight , }}>
            <Button onClick={handleDrawerToggle}>
              {isOpen ? <MenuOpenIcon/> : <MenuIcon sx={{fill:"#ecf0f1"}}/>}
            </Button>
          </DrawerHeader>
          <Divider sx={{backgroundColor:"#ecf0f1"}}/>
          <DrawerContent 
            isOpen={isOpen} 
            handleDrawerClose={handleDrawerClose} 
            selectedIndex2={selectedIndex2} 
            handleListItemClick={handleListItemClick} 
          />
        </PermanentDrawer>
      )}
    </Box>
  );
}