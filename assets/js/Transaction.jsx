
import React from 'react'

export default function Transaction({ transaction }) {
  return (
    <div>
      type: {transaction.transactionType}<br />
      occurred at: {new Date(transaction.occurredAt).toLocaleString()}<br />
      amount: {transaction.amount}<br />
      cpf: {transaction.cpf}<br />
      card: {transaction.card}
    </div>
  )
}