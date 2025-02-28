;; Cross-Simulation Asset Transfer Contract

(define-map assets
  { id: uint }
  {
    owner: principal,
    universe-id: uint,
    asset-type: (string-utf8 50),
    transferable: bool
  }
)

(define-data-var next-asset-id uint u0)

(define-public (create-asset (universe-id uint) (asset-type (string-utf8 50)) (transferable bool))
  (let
    ((new-id (+ (var-get next-asset-id) u1)))
    (var-set next-asset-id new-id)
    (ok (map-set assets
      { id: new-id }
      {
        owner: tx-sender,
        universe-id: universe-id,
        asset-type: asset-type,
        transferable: transferable
      }
    ))
  )
)

(define-public (transfer-asset (asset-id uint) (new-universe-id uint))
  (match (map-get? assets { id: asset-id })
    asset (begin
      (asserts! (is-eq tx-sender (get owner asset)) (err u403))
      (asserts! (get transferable asset) (err u403))
      (ok (map-set assets
        { id: asset-id }
        (merge asset { universe-id: new-universe-id })
      )))
    (err u404)
  )
)

(define-read-only (get-asset (id uint))
  (map-get? assets { id: id })
)

