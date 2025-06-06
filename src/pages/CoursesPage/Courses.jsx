import React from 'react'
import{
  CoursesContainer,
  CoursesHeaderButton,
  CourseGridContainer,
  CourseGridItem,
  CourseCard,
  BoxTwo
} from './CourseStyle';
import { Button,Grid, Stack } from '@mui/material';
import { useSelector,useDispatch } from 'react-redux';
import CourseCardItem from '../../components/Card/CourseCardItem';
import '../../styles/css/global.css'

const courseColors = [
  "black" ,
  "rgba(46, 132, 93, 1)",
  "rgba(48, 166, 106, 1)",
  "rgba(248, 145, 32, 1)",
  "rgba(72, 142, 197, 1)",
  "rgba(200, 73, 84, 1)",
  "rgba(148, 149, 153, 1)",
  "rgba(191, 30, 46, 1)",
  "rgba(118, 75, 40, 1)",
];

function Courses() {

  const {loading,userCourseData} = useSelector((store)=>store.user)

  const dispatch = useDispatch();

  console.log("reduxtaki-userCourseData: ",userCourseData);

  //sayfadaki arkaplan renginin lightgray olmasının sebebi header.css loginpagete yükleniyor bunları engellemenin yolunu bul
  return (
    <div className='courses-body-container' style={{paddingTop: 60 , paddingBottom: 60, backgroundColor: "#f4f4f4" }}>
      <CoursesContainer>
        
        <Stack spacing={8}>

          <Stack direction={{md: "row"}} spacing={{xs:2 , sm:4 , lg: 8}} sx={{justifyContent: "center", alignItems: "center"}}>
            <CoursesHeaderButton variant='contained'>Devam eden Kurslar</CoursesHeaderButton>
            <CoursesHeaderButton variant='contained' color='error'>Süresi Dolan Kurslar</CoursesHeaderButton>
            <CoursesHeaderButton variant='contained' color='success'>Biten Kurslar</CoursesHeaderButton>
          </Stack>

            <Grid container spacing={4} columns={{xs: 2 , sm: 8 , md: 12}}>
              {userCourseData && userCourseData.map((course, index) => (
                <Grid item size={{ xs: 2, sm: 4, md: 4 }} key={index}>
                  <CourseCardItem 
                    title={course.Course} 
                    percentage={Math.floor(course.Grade)} 
                    chartColors={courseColors[index]} 
                  />
                </Grid>
              ))}
            </Grid>

        </Stack>
      </CoursesContainer>
    </div>
  )
}

export default Courses