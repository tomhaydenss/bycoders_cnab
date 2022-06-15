import React from 'react'
import Transaction from "./Transaction";

export default function CompanyTransactions({ items }) {
  return (
    items.map((company, idx) => (
      <div key={idx}>
        Company {company.tradingName} owned by {company.ownerName} with balance {company.balance}<br />
        Financial Transactions:
        {
          company.transactions.map((transaction, idx) =>
            <Transaction transaction={transaction} key={idx} />
          )
        }
      </div>

    ))
  )
}