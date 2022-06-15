import React, { useEffect, useState } from "react";
import { useMutation, useQuery, gql } from '@apollo/client'
import CompanyTransactions from './CompanyTransactions';

const UPLOAD_FILE = gql`
  mutation UploadFile($file: Upload!) {
    uploadFile(file: $file)
  }
`

const COMPANY_TRANSACTIONS = gql`
  query {
    companyTransactions {
      balance
      ownerName
      tradingName
      transactions {
        amount
        card
        cpf
        occurredAt
        transactionType
      } 
    } 
  }
`;

export default function Home() {


  const [uploadFile] = useMutation(UPLOAD_FILE, {
    refetchQueries: [
      COMPANY_TRANSACTIONS
    ]
  });

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

  const companyTransactionsResult = useQuery(COMPANY_TRANSACTIONS);
  const { data: companyTransactionsData } = companyTransactionsResult
  const [companyTransactions, setCompanyTransactions] = useState([]);
  useEffect(() => {
    if (companyTransactionsData) {
      setCompanyTransactions(companyTransactionsData.companyTransactions);
    }
  }, [companyTransactionsData]);

  return (
    <div className="app">
      <h1>CNAB File Parsing</h1>
      <div className="file-upload">
        <h3>Choose a CNAB file for upload</h3>
        <input type="file" required onChange={onChange} />
      </div>
      <hr />

      <CompanyTransactions items={companyTransactions} />
    </div>
  )
}