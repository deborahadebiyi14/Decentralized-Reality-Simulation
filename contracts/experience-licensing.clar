;; Experience Licensing Contract

(define-map licenses
  { id: uint }
  {
    universe-id: uint,
    owner: principal,
    expiration: uint
  }
)

(define-data-var next-license-id uint u0)

(define-public (issue-license (universe-id uint) (owner principal) (duration uint))
  (let
    ((new-id (+ (var-get next-license-id) u1))
     (expiration (+ block-height duration)))
    (var-set next-license-id new-id)
    (ok (map-set licenses
      { id: new-id }
      {
        universe-id: universe-id,
        owner: owner,
        expiration: expiration
      }
    ))
  )
)

(define-read-only (get-license (id uint))
  (map-get? licenses { id: id })
)

(define-read-only (is-license-valid (id uint))
  (match (map-get? licenses { id: id })
    license (< block-height (get expiration license))
    false
  )
)

