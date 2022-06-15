import React from "react";
import { useMutation, gql } from '@apollo/client'

const UPLOAD_FILE = gql`
  mutation UploadFile($file: Upload!) {
    uploadFile(file: $file)
  }
`

export default function Home() {
  const [uploadFile] = useMutation(UPLOAD_FILE);

  function onChange({
    target: {
      validity,
      files: [file],
    },
  }) {
    if (validity.valid) {
      uploadFile({ variables: { file } });
    }
  }

  return (
    <div className="app">
      <h1>CNAB File Parsing</h1>
      <div className="file-upload">
        <h3>Choose a CNAB file for upload</h3>
        <input type="file" required onChange={onChange} />
      </div>
    </div>
  )
}