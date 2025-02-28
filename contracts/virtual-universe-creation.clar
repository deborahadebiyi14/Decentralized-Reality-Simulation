;; Virtual Universe Creation Contract

(define-map universes
  { id: uint }
  {
    name: (string-utf8 100),
    creator: principal,
    active: bool
  }
)

(define-data-var next-universe-id uint u0)

(define-public (create-universe (name (string-utf8 100)))
  (let
    ((new-id (+ (var-get next-universe-id) u1)))
    (var-set next-universe-id new-id)
    (ok (map-set universes
      { id: new-id }
      {
        name: name,
        creator: tx-sender,
        active: true
      }
    ))
  )
)

(define-read-only (get-universe (id uint))
  (map-get? universes { id: id })
)

(define-public (deactivate-universe (id uint))
  (match (map-get? universes { id: id })
    universe (begin
      (asserts! (is-eq tx-sender (get creator universe)) (err u403))
      (ok (map-set universes
        { id: id }
        (merge universe { active: false })
      )))
    (err u404)
  )
)

