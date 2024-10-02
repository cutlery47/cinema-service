package storage

import "errors"

var (
	ErrInternal = errors.New("internal error")
	ErrNotFound = errors.New("not found")
)
