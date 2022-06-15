
import React from 'react'
import DataGrid from 'react-data-grid';

export default function Transactions({ items }) {
  const columns = [
    { key: "transactionType", name: "Type" },
    { key: "occurredAt", name: "Date/Time" },
    { key: "amount", name: "Amount" },
    { key: "cpf", name: "CPF" },
    { key: "card", name: "Card" },
  ]
  return (
     
    <DataGrid columns={columns} rows={items} className="rdg-light"/>
  )
}