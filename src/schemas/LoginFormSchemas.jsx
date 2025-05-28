import * as yup from 'yup'

export const loginFormSchemas = yup.object().shape({
    username: yup.string().email().required("Kullanıcı alanı zorunludur."),
    password: yup.string().required("Şifre alanı zorunludur")
}) 