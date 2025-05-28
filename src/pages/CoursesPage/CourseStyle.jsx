import styled from 'styled-components';
import Container from '@mui/material/Container';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Grid from '@mui/material/Grid';
import { Card } from '@mui/material';

export const CoursesContainer = styled(Container)`
    width : 80vw !important;
`; 

export const CoursesHeaderButton = styled(Button)`
    min-width: 12vw !important;
    text-transform: none !important;

    @media (max-width: 900px) {
        width: 40vw;
    }
    
`

export const CourseGridContainer = styled(Grid)`
    width: 100%;
    background-color:blue;
    size: 12
`;

export const CourseGridItem = styled(Grid)`
    background-color: black;
    color: green
`;


export const BoxTwo = styled(Box)`
    background-color:orange;
`;



export const CourseCard = styled(Card)`

`